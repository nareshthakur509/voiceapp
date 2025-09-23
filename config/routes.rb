Rails.application.routes.draw do
  root "pages#transcribe"
  
  get "/transcribe", to: "pages#transcribe"
  
  resources :transcriptions, only: [:create]
  get "/summary/:id", to: "transcriptions#summary"
  mount ActionCable.server => "/cable"
end