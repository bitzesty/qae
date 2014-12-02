Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    confirmations: 'devise/confirmations'
  }

  get '/dashboard'                 => "content_only#dashboard",                 as: 'dashboard'
  get '/eligibility_check_1'       => "content_only#eligibility_check_1",       as: 'eligibility_check_1'
  get '/eligibility_check_2'       => "content_only#eligibility_check_2",       as: 'eligibility_check_2'
  get '/eligibility_check_3'       => "content_only#eligibility_check_3",       as: 'eligibility_check_3'
  get '/apply_innovation_award'    => "content_only#apply_innovation_award",    as: 'apply_innovation_award'
  get '/innovation_award_eligible' => "content_only#innovation_award_eligible", as: 'innovation_award_eligible'
  get '/innovation_award_form_1'   => "content_only#innovation_award_form_1",   as: 'innovation_award_form_1'
  get '/innovation_award_form_2'   => "content_only#innovation_award_form_2",   as: 'innovation_award_form_2'
  get '/innovation_award_form_3'   => "content_only#innovation_award_form_3",   as: 'innovation_award_form_3'
  get '/innovation_award_form_4'   => "content_only#innovation_award_form_4",   as: 'innovation_award_form_4'
  get '/innovation_award_form_5'   => "content_only#innovation_award_form_5",   as: 'innovation_award_form_5'
  get '/innovation_award_confirm'  => "content_only#innovation_award_confirm",  as: 'innovation_award_confirm'
  get '/account_1'                 => "content_only#account_1",                 as: 'account_1'
  get '/account_2'                 => "content_only#account_2",                 as: 'account_2'
  get '/account_3'                 => "content_only#account_3",                 as: 'account_3'

  root to: 'content_only#home'

  resource :account, only: :show do
    collection do
      get :correspondent_details
      get :company_details
      get :contact_settings

      patch :update_correspondent_details
      patch :update_company_details
      patch :update_contact_settings
    end
  end

  resource :eligibility, only: [:show, :update] do
    collection do
      get :failure
      get :success
    end
  end

  namespace :admin do
    resources :users
  end
end
