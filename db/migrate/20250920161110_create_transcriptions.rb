class CreateTranscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :transcriptions do |t|
      t.text :raw_text, null: false, default: ""
      t.text :summary
      t.string :status, default: "pending" # pending, processing, done, failed
      t.timestamps
    end
  end
end
