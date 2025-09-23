# app/services/transcription_service.rb
require 'rest-client'

class TranscriptionService
  DEEPGRAM_API_KEY = ENV['DEEPGRAM_API_KEY']

  def self.transcribe(file)
    response = RestClient.post(
      'https://api.deepgram.com/v1/listen',
      File.read(file),
      {
        Authorization: "Token #{DEEPGRAM_API_KEY}",
        'Content-Type': 'audio/webm'
      }
    )
    JSON.parse(response.body)['results']['channels'][0]['alternatives'][0]['transcript']
  end
end
