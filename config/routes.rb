Rails.application.routes.draw do
  get '/eligibility'         => "content_only#eligibility",         as: 'eligibility'
  get '/eligibility_success' => "content_only#eligibility_success", as: 'eligibility_success'
  get '/eligibility_failure' => "content_only#eligibility_failure", as: 'eligibility_failure'

  root to: 'content_only#home'
end
