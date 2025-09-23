class Transcription < ApplicationRecord
  has_one_attached :audio

  validates :status, inclusion: { in: %w[pending transcribing summarizing done failed] }
end