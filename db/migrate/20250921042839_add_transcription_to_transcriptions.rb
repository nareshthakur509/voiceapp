class AddTranscriptionToTranscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :transcriptions, :transcription, :text
  end
end
