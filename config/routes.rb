Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    confirmations: 'devise/confirmations'
  }

  devise_for :assessors

  get '/apply-for-queens-award-for-enterprise'          => "content_only#apply_for_queens_award_for_enterprise",          as: 'apply-for-queens-award-for-enterprise'

  get '/terms'                                          => "content_only#terms",                                          as: 'terms'

  get '/awards_for_organisations'                       => "content_only#awards_for_organisations",                       as: 'awards_for_organisations'
  get '/enterprise_promotion_awards'                    => "content_only#enterprise_promotion_awards",                    as: 'enterprise_promotion_awards'
  get '/how_to_apply'                                   => "content_only#how_to_apply",                                   as: 'how_to_apply'
  get '/timeline'                                       => "content_only#timeline",                                       as: 'timeline'
  get '/additional_information_and_contact'             => "content_only#additional_information_and_contact",             as: 'additional_information_and_contact'

  get  '/new_innovation_form'                           => "form#new_innovation_form",                                    as: 'new_innovation_form'
  get  '/new_international_trade_form'                  => "form#new_international_trade_form",                           as: 'new_international_trade_form'
  get  '/new_sustainable_development_form'              => "form#new_sustainable_development_form",                       as: 'new_sustainable_development_form'
  get  '/new_enterprise_promotion_form'                 => "form#new_enterprise_promotion_form",                          as: 'new_enterprise_promotion_form'
  get  '/form/:id'                                      => "form#edit_form",                                              as: 'edit_form'
  post '/form_autosave/:id'                             => "form#autosave",                                               as: 'autosave'
  post '/form/:id'                                      => "form#submit_form",                                            as: 'submit_form'
  post '/form/:id/attachments'                          => "form#add_attachment",                                         as: 'attachments'
  get  '/form/:id/confirmation'                         => "form#submit_confirm",                                         as: 'submit_confirm'
  get '/dashboard'                                      => "content_only#dashboard",                                      as: 'dashboard'

  get '/apply_innovation_award'                         => "content_only#apply_innovation_award",                         as: 'apply_innovation_award'
  get '/innovation_award_eligible_failure'              => "content_only#innovation_award_eligible_failure",              as: 'innovation_award_eligible_failure'

  get '/apply_international_trade_award'                => "content_only#apply_international_trade_award",                as: 'apply_international_trade_award'
  get '/international_trade_award_eligible_failure'     => "content_only#international_trade_award_eligible_failure",     as: 'trade_award_eligible_failure'

  get '/apply_sustainable_development_award'            => "content_only#apply_sustainable_development_award",            as: 'apply_sustainable_development_award'
  get '/sustainable_development_award_eligible_failure' => "content_only#sustainable_development_award_eligible_failure", as: 'development_award_eligible_failure'

  get '/apply_enterprise_promotion_award'               => "content_only#apply_enterprise_promotion_award",               as: 'apply_enterprise_promotion_award'

  root to: 'content_only#home'

  resource :account, only: :show do
    collection do
      get :correspondent_details
      get :company_details
      get :contact_settings
      get :password_settings

      patch :update_correspondent_details
      patch :update_company_details
      patch :update_contact_settings
      patch :complete_registration
      patch :update_password_settings
    end
  end

  resource :form_award_eligibility, only: [:show, :update] do
   collection do
      get :result
    end
  end

  resource :support_letter, only: [:show, :update]

  namespace :users do
    resources :form_answers, only: [:show] do
      resource :audit_certificate, only: [:show, :create]
    end
  end

  namespace :assessor do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :settings, only: [:index]
    resources :users
    resources :assessors
    resources :admins
    resources :reports, only: [:show]
    resources :form_answers do
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]

      resources :flags, only: [] do
        collection{ get :toggle }
      end
      member do
        post :withdraw
        get :review
      end
    end

    resources :notifications, only: [] do
      collection do
        get :confirm_notify_shortlisted
        get :confirm_notify_non_shortlisted
        post :trigger_notify_shortlisted
        post :trigger_notify_non_shortlisted
      end
    end
  end

  namespace :account do
    resources :collaborators, except: [:edit, :update, :show]
  end
end
