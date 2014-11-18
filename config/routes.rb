Rails.application.routes.draw do
  get '/eligibility' => "content_only#eligibility", as: 'eligibility'

  root to: 'content_only#home'
end
