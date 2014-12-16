Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    confirmations: 'devise/confirmations'
  }

  get '/apply-for-queens-award-for-enterprise'          => "content_only#apply_for_queens_award_for_enterprise",          as: 'apply-for-queens-award-for-enterprise'

  get '/terms'                                          => "content_only#terms",                                          as: 'terms'

  get '/awards_for_organisations'                       => "content_only#awards_for_organisations",                       as: 'awards_for_organisations'
  get '/enterprise_promotion_awards'                    => "content_only#enterprise_promotion_awards",                    as: 'enterprise_promotion_awards'
  get '/how_to_apply'                                   => "content_only#how_to_apply",                                   as: 'how_to_apply'
  get '/what_happens_next'                              => "content_only#what_happens_next",                              as: 'what_happens_next'
  get '/additional_information_and_contact'             => "content_only#additional_information_and_contact",             as: 'additional_information_and_contact'

  get  '/new_innovation_form'                           => "form#new_innovation_form",                                    as: 'new_innovation_form'
  get  '/new_international_trade_form'                  => "form#new_international_trade_form",                           as: 'new_international_trade_form'
  get  '/new_sustainable_development_form'              => "form#new_sustainable_development_form",                       as: 'new_sustainable_development_form'
  get  '/form/:id'                                      => "form#edit_form",                                              as: 'edit_form'
  post '/form_autosave/:id'                             => "form#autosave",                                               as: 'autosave'
  post '/form/:id'                                      => "form#submit_form",                                            as: 'submit_form'
  get  '/form/:id/confirmation'                         => "form#submit_confirm",                                         as: 'submit_confirm'
  get '/dashboard'                                      => "content_only#dashboard",                                      as: 'dashboard'
  get '/eligibility_check_1'                            => "content_only#eligibility_check_1",                            as: 'eligibility_check_1'
  get '/eligibility_check_2'                            => "content_only#eligibility_check_2",                            as: 'eligibility_check_2'
  get '/eligibility_check_3'                            => "content_only#eligibility_check_3",                            as: 'eligibility_check_3'
  get '/eligibility_check_success'                      => "content_only#eligibility_check_success",                      as: 'eligibility_check_success'

  get '/apply_innovation_award'                         => "content_only#apply_innovation_award",                         as: 'apply_innovation_award'
  get '/innovation_award_eligible'                      => "content_only#innovation_award_eligible",                      as: 'innovation_award_eligible'
  get '/innovation_award_eligible_failure'              => "content_only#innovation_award_eligible_failure",              as: 'innovation_award_eligible_failure'
  get '/innovation_award_form_1'                        => "content_only#innovation_award_form_1",                        as: 'innovation_award_form_1'
  get '/innovation_award_form_2'                        => "content_only#innovation_award_form_2",                        as: 'innovation_award_form_2'
  get '/innovation_award_form_3'                        => "content_only#innovation_award_form_3",                        as: 'innovation_award_form_3'
  get '/innovation_award_form_4'                        => "content_only#innovation_award_form_4",                        as: 'innovation_award_form_4'
  get '/innovation_award_form_5'                        => "content_only#innovation_award_form_5",                        as: 'innovation_award_form_5'
  get '/innovation_award_confirm'                       => "content_only#innovation_award_confirm",                       as: 'innovation_award_confirm'

  get '/apply_international_trade_award'                => "content_only#apply_international_trade_award",                as: 'apply_international_trade_award'
  get '/international_trade_award_eligible'             => "content_only#international_trade_award_eligible",             as: 'international_trade_award_eligible'
  get '/international_trade_award_eligible_failure'     => "content_only#international_trade_award_eligible_failure",     as: 'trade_award_eligible_failure'
  get '/international_trade_award_form_1'               => "content_only#international_trade_award_form_1",               as: 'international_trade_award_form_1'
  get '/international_trade_award_form_2'               => "content_only#international_trade_award_form_2",               as: 'international_trade_award_form_2'
  get '/international_trade_award_form_3'               => "content_only#international_trade_award_form_3",               as: 'international_trade_award_form_3'
  get '/international_trade_award_form_4'               => "content_only#international_trade_award_form_4",               as: 'international_trade_award_form_4'
  get '/international_trade_award_form_5'               => "content_only#international_trade_award_form_5",               as: 'international_trade_award_form_5'
  get '/international_trade_award_confirm'              => "content_only#international_trade_award_confirm",              as: 'international_trade_award_confirm'

  get '/apply_sustainable_development_award'            => "content_only#apply_sustainable_development_award",            as: 'apply_sustainable_development_award'
  get '/sustainable_development_award_eligible'         => "content_only#sustainable_development_award_eligible",         as: 'sustainable_development_award_eligible'
  get '/sustainable_development_award_eligible_failure' => "content_only#sustainable_development_award_eligible_failure", as: 'development_award_eligible_failure'
  get '/sustainable_development_award_form_1'           => "content_only#sustainable_development_award_form_1",           as: 'sustainable_development_award_form_1'
  get '/sustainable_development_award_form_2'           => "content_only#sustainable_development_award_form_2",           as: 'sustainable_development_award_form_2'
  get '/sustainable_development_award_form_3'           => "content_only#sustainable_development_award_form_3",           as: 'sustainable_development_award_form_3'
  get '/sustainable_development_award_form_4'           => "content_only#sustainable_development_award_form_4",           as: 'sustainable_development_award_form_4'
  get '/sustainable_development_award_form_5'           => "content_only#sustainable_development_award_form_5",           as: 'sustainable_development_award_form_5'
  get '/sustainable_development_award_confirm'          => "content_only#sustainable_development_award_confirm",          as: 'sustainable_development_award_confirm'

  get '/account_1'                                      => "content_only#account_1",                                      as: 'account_1'
  get '/account_2'                                      => "content_only#account_2",                                      as: 'account_2'
  get '/account_3'                                      => "content_only#account_3",                                      as: 'account_3'

  root to: 'content_only#home'

  resource :account, only: :show do
    collection do
      get :correspondent_details
      get :company_details
      get :contact_settings
      get :add_collaborators
      get :password_settings

      patch :update_correspondent_details
      patch :update_company_details
      patch :update_contact_settings
      patch :update_add_collaborators
      patch :update_password_settings
    end
  end

  resource :eligibility, only: [:show, :update] do
    collection do
      get :failure
    end
  end

  resource :award_eligibility, only: [:show, :update] do
    collection do
      get :result
    end
  end

  resource :form_award_eligibility, only: [:show, :update] do
   collection do
      get :result
    end
  end

  resources :users, only: [], module: 'users' do
    resources :form_answers, only: [:show]
  end

  namespace :admin do
    resources :users
    resources :form_answers do
      member do
        post :withdraw
        get :review
      end
    end
  end

  namespace :account do
    resources :users
  end
end
