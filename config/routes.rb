Rails.application.routes.draw do
  get '/eligibility' => "content_only#eligibility", as: 'eligibility'
  get '/eligibility_success' => "content_only#eligibility_success", as: 'eligibility_success'

  root to: 'content_only#home'
end
