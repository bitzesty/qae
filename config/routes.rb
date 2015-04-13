Rails.application.routes.draw do
  resource :healthcheck, only: :show

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_for :admins, controllers: {
    confirmations: "devise/confirmations",
    devise_authy: "admin/devise_authy"
  }, path_names: {
    verify_authy: "/verify-token",
    enable_authy: "/enable-two-factor",
    verify_authy_installation: "/verify-installation"
  }

  devise_for :assessors

  get "/apply-for-queens-award-for-enterprise"          => "content_only#apply_for_queens_award_for_enterprise",          as: "apply-for-queens-award-for-enterprise"

  get "/sign_up_complete"                               => "content_only#sign_up_complete",                               as: "sign_up_complete"

  get "/privacy"                                        => "content_only#privacy",                                        as: "privacy"

  get "/awards_for_organisations"                       => "content_only#awards_for_organisations",                       as: "awards_for_organisations"
  get "/enterprise_promotion_awards"                    => "content_only#enterprise_promotion_awards",                    as: "enterprise_promotion_awards"
  get "/how_to_apply"                                   => "content_only#how_to_apply",                                   as: "how_to_apply"
  get "/timeline"                                       => "content_only#timeline",                                       as: "timeline"
  get "/additional_information_and_contact"             => "content_only#additional_information_and_contact",             as: "additional_information_and_contact"

  get  "/new_innovation_form"                           => "form#new_innovation_form",                                    as: "new_innovation_form"
  get  "/new_international_trade_form"                  => "form#new_international_trade_form",                           as: "new_international_trade_form"
  get  "/new_sustainable_development_form"              => "form#new_sustainable_development_form",                       as: "new_sustainable_development_form"
  get  "/new_enterprise_promotion_form"                 => "form#new_enterprise_promotion_form",                          as: "new_enterprise_promotion_form"
  get  "/form/:id"                                      => "form#edit_form",                                              as: "edit_form"
  post "/form/:id"                                      => "form#save",                                                   as: "save_form"
  post "/form/:id/attachments"                          => "form#add_attachment",                                         as: "attachments"
  get  "/form/:id/confirmation"                         => "form#submit_confirm",                                         as: "submit_confirm"
  get "/dashboard"                                      => "content_only#dashboard",                                      as: "dashboard"

  get "/apply_innovation_award"                         => "content_only#apply_innovation_award",                         as: "apply_innovation_award"
  get "/award_info_innovation"                          => "content_only#award_info_innovation",                          as: "award_info_innovation"
  get "/innovation_award_eligible_failure"              => "content_only#innovation_award_eligible_failure",              as: "innovation_award_eligible_failure"

  get "/apply_international_trade_award"                => "content_only#apply_international_trade_award",                as: "apply_international_trade_award"
  get "/award_info_trade"                               => "content_only#award_info_trade",                               as: "award_info_trade"
  get "/international_trade_award_eligible_failure"     => "content_only#international_trade_award_eligible_failure",     as: "trade_award_eligible_failure"

  get "/apply_sustainable_development_award"            => "content_only#apply_sustainable_development_award",            as: "apply_sustainable_development_award"
  get "/award_info_development"                         => "content_only#award_info_development",                         as: "award_info_development"
  get "/sustainable_development_award_eligible_failure" => "content_only#sustainable_development_award_eligible_failure", as: "development_award_eligible_failure"

  get "/apply_enterprise_promotion_award"               => "content_only#apply_enterprise_promotion_award",               as: "apply_enterprise_promotion_award"
  get "/award_info_promotion"                           => "content_only#award_info_promotion",                           as: "award_info_promotion"

  get "/declaration_of_corporate_responsibility"        => "content_only#declaration_of_corporate_responsibility",        as: "declaration_of_corporate_responsibility"
  get "/award_winners_section"                          => "content_only#award_winners_section",                          as: "award_winners_section"
  get "/press_comment"                                  => "content_only#press_comment",                                  as: "press_comment"
  get "/buckingham_palace_attendance"                   => "content_only#buckingham_palace_attendance",                   as: "buckingham_palace_attendance"
  get "/submitted_nomination_successful"                => "content_only#submitted_nomination_successful",                as: "submitted_nomination_successful"

  root to: "content_only#home"

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

  resources :palace_invites, only: [:edit, :update]

  namespace :users do
    resources :form_answers, only: [:show] do
      resource :audit_certificate, only: [:show, :create, :destroy]
      resource :support_letter_attachments, only: :create
      resource :supporters, only: :create
      resource :support_letters, only: :create
      resource :press_summary, only: [:show, :update] do
        get :acceptance
        post :update_acceptance
      end

      resources :form_attachments_and_links, only: [:index, :create, :destroy] # NON JS
    end
  end

  namespace :form do
    resources :form_answers do
      resources :supporters, only: [:new, :create, :index]
      resources :support_letters, only: [:new, :create, :destroy]
    end
  end

  namespace :assessor do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :company_details, only: [:update]
    resources :palace_attendees, only: [:new, :create, :update, :destroy]
    resources :review_audit_certificates, only: [:create]

    resources :form_answers do
      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :audit_certificates, only: [:show]
      resources :feedbacks, only: [:create, :update] do
        member do
          post :submit
          post :approve
        end
      end

      resources :press_summaries, only: [:create, :update] do
        member do
          post :approve
        end
      end

      member { get(:review) }
      resources :flags, only: [] do
        collection { post :toggle }
      end
      resources :draft_notes, only: [:create, :update]
    end
    resources :assessor_assignments, only: [:update]
    resources :assessment_submissions, only: [:create]
    resources :assessor_assignment_collections, only: [:create]
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :users
    resources :assessors
    resources :admins
    resources :reports, only: [:show] do
      collection do
        get :download_feedbacks_pdf
        get :download_case_summary_pdf
      end
    end
    resources :review_audit_certificates, only: [:create]
    resources :company_details, only: [:update]
    resources :palace_attendees, only: [:new, :create, :update, :destroy]

    resources :form_answers do
      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :audit_certificates, only: [:show]
      resources :feedbacks, only: [:create, :update] do
        member do
          post :submit
          post :approve
        end

        get :download_pdf, on: :collection
      end

      resources :press_summaries, only: [:create, :update] do
        member do
          post :approve
        end
      end
      resources :case_summaries, only: [:index]

      resources :draft_notes, only: [:create, :update]

      resources :flags, only: [] do
        collection { post :toggle }
      end
      member do
        patch :update_financials
        get :review
      end
    end

    resource :settings, only: [:show] do
      resources :deadlines, only: [:update]
      resources :email_notifications, only: [:create, :update, :destroy]
    end

    resources :assessor_assignments, only: [:update]
    resources :assessment_submissions, only: [:create]
  end

  namespace :account do
    resources :collaborators, except: [:edit, :update, :show]
  end
end
