require 'rails_helper'

RSpec.describe "Transcriptions", type: :request do
  describe "GET /summary/:id" do
    it "returns summary when present" do
      t = Transcription.create!(summary: "Short summary", status: "done")

      get "/summary/#{t.id}"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["summary"]).to eq("Short summary")
    end

    it "returns error when summary is missing" do
      t = Transcription.create!(status: "processing")

      get "/summary/#{t.id}"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Summary not ready yet")
    end
  end
end