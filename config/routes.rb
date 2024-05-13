require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  Healthcheck.routes(self)
  # Content Security Policy report_uri (http://content-security-policy.com/)
  post "/csp_report_uri", to: "csp_report_uri#report"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    sessions: "users/sessions",
    unlocks: "users/unlocks",
  }

  devise_for :admins, controllers: {
    confirmations: "admins/confirmations",
    devise_authy: "admin/devise_authy",
  }, path_names: {
    verify_authy: "/verify-token",
    enable_authy: "/enable-two-factor",
    verify_authy_installation: "/verify-installation",
  }

  authenticate :admin do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :assessors, controllers: {
    confirmations: "assessors/confirmations",
  }
  devise_for :judges, controllers: {
    confirmations: "judges/confirmations",
  }

  get "/awards_for_organisations" => redirect("https://www.gov.uk/kings-awards-for-enterprise/business-awards")
  get "/enterprise_promotion_awards" => redirect("https://www.gov.uk/kings-awards-for-enterprise/enterprise-promotion-award")
  get "/how_to_apply" => redirect("https://www.gov.uk/kings-awards-for-enterprise/how-to-apply")
  get "/timeline" => redirect("https://www.gov.uk/kings-awards-for-enterprise/timeline")
  get "/additional_information_and_contact" => redirect("https://www.gov.uk/kings-awards-for-enterprise/how-to-apply")
  get "/apply-for-kings-award-for-enterprise" => redirect("https://www.gov.uk/kings-awards-for-enterprise/how-to-apply")

  get "/sign_up_complete" => "content_only#sign_up_complete", as: "sign_up_complete"
  get "/privacy" => "content_only#privacy", as: "privacy"
  get "/cookies" => "content_only#cookies", as: "cookies"
  get "/accessibility-statement" => "content_only#accessibility_statement", as: "accessibility_statement"

  get "/new_innovation_form" => "form#new_innovation_form", as: "new_innovation_form"
  get "/new_international_trade_form" => "form#new_international_trade_form", as: "new_international_trade_form"
  get "/new_sustainable_development_form" => "form#new_sustainable_development_form", as: "new_sustainable_development_form"
  get "/new_social_mobility_form" => "form#new_social_mobility_form", as: "new_social_mobility_form"

  get "/form/:id" => "form#edit_form", as: "edit_form"
  post "/form/:id" => "form#save", as: "save_form"
  post "/form/:id/attachments" => "form#add_attachment", as: "attachments"
  get "/form/:id/confirmation" => "form#submit_confirm", as: "submit_confirm"
  get "/dashboard" => "content_only#dashboard", as: "dashboard"

  get "/apply_innovation_award" => "content_only#apply_innovation_award", as: "apply_innovation_award"
  get "/award_info_innovation" => "content_only#award_info_innovation", as: "award_info_innovation"

  get "/apply_international_trade_award" => "content_only#apply_international_trade_award", as: "apply_international_trade_award"
  get "/award_info_trade" => "content_only#award_info_trade", as: "award_info_trade"

  get "/apply_sustainable_development_award" => "content_only#apply_sustainable_development_award", as: "apply_sustainable_development_award"
  get "/award_info_development" => "content_only#award_info_development", as: "award_info_development"
  get "/apply_social_mobility_award" => "content_only#apply_social_mobility_award", as: "apply_social_mobility_award"
  get "/award_info_mobility" => "content_only#award_info_mobility", as: "award_info_mobility"

  get "/award_winners_section" => "content_only#award_winners_section", as: "award_winners_section"

  root to: QAE.production? ? redirect("https://www.gov.uk/kings-awards-for-enterprise/how-to-apply") : "content_only#dashboard"

  resource :account, only: :show do
    collection do
      get :correspondent_details
      get :company_details
      get :contact_settings
      get :password_settings
      get :additional_contact_preferences
      get :useful_information

      patch :update_correspondent_details
      patch :update_company_details
      patch :update_contact_settings
      patch :complete_registration
      patch :update_password_settings
      patch :update_additional_contact_preferences
    end
  end

  resource :form_award_eligibility, only: [:show, :update] do
   collection do
      get :warning
      get :result
   end
  end

  resource :support_letter, only: [:new, :show, :create]
  resource :feedback, only: [:show, :create] do
    get :success
  end

  namespace :users do
    resources :form_answers, only: [:show] do
      resources :collaborator_access, only: [] do
        collection do
          get "auth/:section/:timestamp" => "collaborator_access#auth"
        end
      end

      # shortlisted docs block
      resource :audit_certificate, only: [:show, :create, :destroy]
      resource :figures_and_vat_returns, only: [:show] do
        patch :submit, on: :member
      end

      resources :actual_figures, only: [:new, :show, :create, :destroy]
      resources :vat_returns, only: [:new, :show, :create, :destroy]

      resource :support_letter_attachments, only: :create
      resources :supporters, only: [:create, :destroy]
      resources :support_letters, only: [:create, :show, :destroy]
      resource :press_summary, only: [:show, :update] do
        get :acceptance
        get :success
        get :failure
        post :update_acceptance
      end
    end
    resources :form_answer_feedbacks, only: [:show]
  end

  resource :palace_invite, only: [:edit, :update] do
    resource :expired_palace_invite, only: [:show], as: "expired", path: "expired", on: :member
  end

  # NON JS implementation - begin
  namespace :form do
    resources :form_answers do
      resources :supporters, only: [:new, :create, :index, :destroy]
      resources :support_letters, only: [:new, :create, :destroy]
      resources :form_attachments, only: [:index, :new, :create, :destroy] do
        get :confirm_deletion
      end
      resources :organisational_charts, only: [:new, :create, :destroy] do
        get :confirm_deletion
      end
      resource :positions, only: [:new, :create, :edit, :update, :destroy] do
        get :index, on: :collection
      end

      [
        :current_queens_awards,
        :awards,
        :subsidiaries,
        :form_links,
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
    resources :palace_invites, only: [] do
      member do
        post :submit
      end
    end

    get :suspended, to: "dashboard#suspended"

    resources :review_audit_certificates, only: [:create]
    resources :review_commercial_figures, only: [:create]

    resources :form_answers do
      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :audit_certificates, only: [:show, :create]
      resources :commercial_figures_files, only: [:create, :show, :destroy]
      resources :vat_returns_files, only: [:create, :show, :destroy]
      resources :shortlisted_documents_submissions, only: [:create]

      resources :feedbacks, only: [:create, :update] do
        member do
          post :submit
          post :unlock
        end
      end

      resources :press_summaries, only: [:create, :update] do
        member do
          post :approve
          post :submit
          post :unlock
        end
      end

      member do
        patch :update_financials
        get :review
      end
      resources :draft_notes, only: [:create, :update]
    end

    resources :assessor_assignments, only: [:update]
    resources :assessor_assignment_collections, only: [:create]
    resources :reports, only: [:index, :show]

    resources :assessment_submissions, only: [:create] do
      patch :unlock, on: :member
    end

    scope format: true, constraints: { format: "json" } do
      resource :session_checks, only: [:show]
      post "session_checks/extend" => "session_checks#extend"
    end
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index] do
      collection do
        get :totals_by_month
        get :totals_by_week
        get :totals_by_day
        get :downloads
      end
    end

    resources :dashboard_reports, only: [] do
      collection do
        get :all_applications
        get :international_trade
        get :social_mobility
        get :innovation
        get :sustainable_development
        get :account_registrations
      end
    end

    resources :users_reports, only: [] do
      collection do
        get :assessors_judges_admins_data
      end
    end

    resources :users, except: [:destroy] do
      member do
        patch :resend_confirmation_email
        patch :unlock
        post :scan_via_debounce_api
      end
    end

    resources :collaborator_deletion, only: [:destroy]

    resources :assessors do
      member do
        get :confirm_activate
        get :confirm_deactivate
        patch :activate
        patch :deactivate
      end

      collection do
        get :suspension_status

        get :confirm_bulk_activate_pi
        get :confirm_bulk_deactivate_pi
        get :confirm_bulk_activate_dt
        get :confirm_bulk_deactivate_dt

        put :bulk_activate_pi
        put :bulk_deactivate_pi
        put :bulk_activate_dt
        put :bulk_deactivate_dt
      end
    end
    resources :judges

    resources :admins do
      collection do
        # NOTE: debug abilities for Admin
        get :login_as_assessor
        get :login_as_user
      end
    end
    resources :reports, only: [:show] do
      get :import_csv_into_ms_excel_guide_pdf, on: :collection
    end
    resources :review_audit_certificates, only: [:create]
    resources :review_commercial_figures, only: [:create]
    resources :palace_attendees, only: [:new, :create, :update, :destroy]
    resources :palace_invites, only: [] do
      member do
        post :submit
      end
    end

    resources :form_answers do
      collection do
        get :awarded_trade_applications
      end

      member do
        patch :remove_audit_certificate
        patch :update_financials
        get :review
      end

      resources :form_answer_state_transitions, only: [:create]
      resources :comments
      resources :form_answer_attachments, only: [:create, :show, :destroy]
      resources :support_letters, only: [:show]
      resources :audit_certificates, only: [:show, :create] do
        get :download_initial_pdf, on: :collection
      end
      resources :commercial_figures_files, only: [:create, :show, :destroy]
      resources :vat_returns_files, only: [:create, :show, :destroy]
      resources :shortlisted_documents_submissions, only: [:create]

      resources :feedbacks, only: [:create, :update] do
        member do
          post :submit
          post :unlock
        end

        get :download_pdf, on: :collection
      end
      resources :press_summaries, only: [:create, :update] do
        member do
          post :approve
          post :submit
          post :unlock
          post :signoff
        end
      end
      resources :case_summaries, only: [:index]
      resources :draft_notes, only: [:create, :update]
      resources :review_corp_responsibility, only: [:create]
      resources :collaborators, only: [:create], module: "form_answers" do
        get :search, on: :collection
      end
    end

    resource :settings, only: [:show] do
      resources :deadlines, only: [:update]
      resources :email_notifications, only: [:create, :update, :destroy] do
        collection do
          post :run_notifications
        end
      end
    end

    resources :assessor_assignments, only: [:update]
    resources :assessment_submissions, only: [:create] do
      patch :unlock, on: :member
    end

    resource :custom_email, only: [:show, :create]
    resource :users_feedback, only: [:show]
    resources :audit_logs, only: :index

    scope format: true, constraints: { format: "json" } do
      resource :session_checks, only: [:show]
      post "session_checks/extend" => "session_checks#extend"
    end
  end

  namespace :account do
    resources :collaborators, except: [:show] do
      member do
        get :confirm_deletion
      end
    end
  end

  namespace :judge do
    root to: "case_summaries#index"
    resources :case_summaries, only: :index do
      get :download, on: :collection
    end

    scope format: true, constraints: { format: "json" } do
      resource :session_checks, only: [:show]
      post "session_checks/extend" => "session_checks#extend"
    end
  end
end
