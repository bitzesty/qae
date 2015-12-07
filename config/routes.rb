Rails.application.routes.draw do
  # Virus Scanner integration - begin
  namespace :vs_rails do
    resources :scans, only: [] do
      post :callback, on: :collection
    end
  end
  # Virus Scanner integration - end

  resource :healthcheck, only: :show

  # Content Security Policy report_uri (http://content-security-policy.com/)
  resource :csp_report_uri, only: :show

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

  get "/awards_for_organisations"                       => redirect("https://www.gov.uk/queens-awards-for-enterprise/business-awards")
  get "/enterprise_promotion_awards"                    => redirect("https://www.gov.uk/queens-awards-for-enterprise/enterprise-promotion-award")
  get "/how_to_apply"                                   => redirect("https://www.gov.uk/queens-awards-for-enterprise/how-to-apply")
  get "/timeline"                                       => redirect("https://www.gov.uk/queens-awards-for-enterprise/timeline")
  get "/additional_information_and_contact"             => redirect("https://www.gov.uk/queens-awards-for-enterprise/how-to-apply")
  get "/apply-for-queens-award-for-enterprise"          => redirect("https://www.gov.uk/apply-queens-award-enterprise")

  get "/sign_up_complete"                               => "content_only#sign_up_complete",                               as: "sign_up_complete"
  get "/privacy"                                        => "content_only#privacy",                                        as: "privacy"
  get "/cookies"                                        => "content_only#cookies",                                        as: "cookies"

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

  get "/apply_international_trade_award"                => "content_only#apply_international_trade_award",                as: "apply_international_trade_award"
  get "/award_info_trade"                               => "content_only#award_info_trade",                               as: "award_info_trade"

  get "/apply_sustainable_development_award"            => "content_only#apply_sustainable_development_award",            as: "apply_sustainable_development_award"
  get "/award_info_development"                         => "content_only#award_info_development",                         as: "award_info_development"

  get "/apply_enterprise_promotion_award"               => "content_only#apply_enterprise_promotion_award",               as: "apply_enterprise_promotion_award"
  get "/award_info_promotion"                           => "content_only#award_info_promotion",                           as: "award_info_promotion"

  get "/award_winners_section"                          => "content_only#award_winners_section",                          as: "award_winners_section"

  root to: Rails.env.production? ? redirect("https://www.gov.uk/apply-queens-award-enterprise ") : "content_only#dashboard"

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

  resource :support_letter, only: [:new, :show, :create]
  resource :feedback, only: [:show, :create] do
    get :success
  end

  resources :palace_invites, only: [:edit, :update]

  namespace :users do
    resources :form_answers, only: [:show] do
      resource :audit_certificate, only: [:show, :create]
      resource :support_letter_attachments, only: :create
      resources :supporters, only: [:create, :destroy]
      resources :support_letters, only: [:create, :show, :destroy]
      resource :press_summary, only: [:show, :update] do
        get :acceptance
        get :success
        get :failure
        post :update_acceptance
      end
      resource :declaration_of_responsibility, only: [:edit, :update]
    end
    resources :form_answer_feedbacks, only: [:show]
  end

  # NON JS implementation - begin
  namespace :form do
    resources :form_answers do
      resources :supporters, only: [:new, :create, :index, :destroy]
      resources :support_letters, only: [:new, :create, :destroy]
      resources :form_attachments, only: [:index, :new, :create, :destroy]
      resource :form_links, only: [:new, :create, :destroy]
      resources :organisational_charts, only: [:new, :create, :destroy] do
        get :confirm_deletion
      end
      resource :positions, only: [:new, :create, :edit, :update, :destroy] do
        get :index, on: :collection
      end

      [
        :current_queens_awards,
        :awards,
        :subsidiaries
      ].each do |resource_name|
        resource resource_name, only: [:new, :create, :edit, :update, :destroy] do
          get :confirm_deletion
        end
      end
    end
  end
  # NON JS implementation - end

  namespace :assessor do
    root to: "form_answers#index"
    resources :palace_attendees, only: [:new, :create, :update, :destroy]
    resources :review_audit_certificates, only: [:create]

    resources :form_answers do
      member do
        get :original_pdf_before_deadline
      end

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

      member do
        patch :update_financials
        get :review
      end
      resources :draft_notes, only: [:create, :update]

      resources :review_corp_responsibility, only: [:create]
    end
    resources :assessor_assignments, only: [:update]
    resources :assessment_submissions, only: [:create]
    resources :assessor_assignment_collections, only: [:create]
    resources :reports, only: [:show]
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :users do
      member do
        patch :resend_confirmation_email
        patch :unlock
      end
    end
    resources :assessors
    resources :admins
    resources :reports, only: [:show]
    resources :review_audit_certificates, only: [:create]
    resources :palace_attendees, only: [:new, :create, :update, :destroy]

    resources :form_answers do
      member do
        get :original_pdf_before_deadline
        patch :remove_audit_certificate
      end

      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :audit_certificates, only: [:show] do
        get :download_initial_pdf, on: :collection
      end
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

      member do
        patch :update_financials
        get :review
      end

      resources :review_corp_responsibility, only: [:create]
    end

    resource :settings, only: [:show] do
      resources :deadlines, only: [:update]
      resources :email_notifications, only: [:create, :update, :destroy]
    end

    resources :assessor_assignments, only: [:update]
    resources :assessment_submissions, only: [:create]

    resource :custom_email, only: [:show, :create]
    resource :users_feedback, only: [:show]
  end

  namespace :account do
    resources :collaborators, except: [:edit, :update, :show]
  end
end
