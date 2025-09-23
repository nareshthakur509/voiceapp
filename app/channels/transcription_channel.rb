class TranscriptionChannel < ApplicationCable::Channel
  def subscribed
    transcription = Transcription.find(params[:id])
    stream_for transcription
  end
end