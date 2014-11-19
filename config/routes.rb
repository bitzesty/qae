Rails.application.routes.draw do
  get '/eligibility'            => "content_only#eligibility",            as: 'eligibility'
  get '/eligibility_success'    => "content_only#eligibility_success",    as: 'eligibility_success'
  get '/eligibility_failure'    => "content_only#eligibility_failure",    as: 'eligibility_failure'
  get '/eligibility_check'      => "content_only#eligibility_check",      as: 'eligibility_check'
  get '/apply_innovation_award' => "content_only#apply_innovation_award", as: 'apply_innovation_award'
  get '/confirmation'           => "content_only#confirmation",           as: 'confirmation'
  get '/account'                => "content_only#account",                as: 'account'

  root to: 'content_only#home'
end
