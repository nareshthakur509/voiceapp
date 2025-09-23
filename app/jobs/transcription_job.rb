class TranscriptionJob < ApplicationJob
  queue_as :default
  require "openai"

  def perform(transcription_id)
    transcription = Transcription.find(transcription_id)
    transcription.update!(status: "transcribing")

    return unless transcription.audio.attached?

    audio_file = Rails.root.join("tmp", "audio_#{transcription.id}.webm")
    File.open(audio_file, "wb") { |f| f.write(transcription.audio.download) }

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    #Transcribe using Whisper
    transcription_result = client.audio.transcribe(
      parameters: {
        model: "whisper-1",
        file: File.open(audio_file)
      }
    )
    final_text = transcription_result["text"] || "Transcription failed"

    transcription.update!(transcription: final_text, status: "summarizing")
    TranscriptionChannel.broadcast_to(
      transcription,
      final_transcription: final_text,
      status: "summarizing"
    )

    #Generate summary using GPT
    summary_result = client.chat.completions(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: "Summarize the text below concisely." },
          { role: "user", content: final_text }
        ],
        max_tokens: 300
      }
    )

    summary_text = summary_result.dig("choices", 0, "message", "content") || "Summary failed"

    transcription.update!(status: "done", summary: summary_text)
    TranscriptionChannel.broadcast_to(
      transcription,
      summary: summary_text,
      status: "done"
    )
  ensure
    File.delete(audio_file) if audio_file && File.exist?(audio_file)
  end
end
