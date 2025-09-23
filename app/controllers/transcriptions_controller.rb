class TranscriptionsController < ApplicationController
  def create
    transcription = Transcription.create!
    transcription.audio.attach(params[:audio])

    TranscriptionJob.perform_later(transcription.id)

    render json: { id: transcription.id, status: transcription.status }
  end

  def summary
    transcription = Transcription.find(params[:id])
    render json: {
      id: transcription.id,
      status: transcription.status,
      transcription: transcription.raw_text,
      summary: transcription.summary
    }
  end
end
