require "qae_2014_forms"

class FormController < ApplicationController
  before_action :authenticate_user!, :check_account_completion
  before_action :set_form_answer, :except => [:new_innovation_form, :new_international_trade_form, :new_sustainable_development_form, :new_enterprise_promotion_form]
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy,
    :submit_form,
    :submit_confirm,
    :autosave
  ]
  before_action :require_to_be_account_admin!, only: [:submit_form, :submit_confirm]
  before_action :check_trade_count_limit, only: :new_international_trade_form

  expose(:support_letter_attachments) do
    @form_answer.support_letter_attachments.inject({}) do |r, attachment|
      r[attachment.id] = attachment
      r
    end
  end

  def new_innovation_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "innovation",
      nickname: params[:nickname],
      document: {
        company_name: current_user.company_name,
        principal_address_building: current_user.company_address_first,
        principal_address_street: current_user.company_address_second,
        principal_address_city: current_user.company_city,
        principal_address__country: current_user.company_country,
        principal_address_postcode: current_user.company_postcode
    })
    redirect_to edit_form_url(form_answer)
  end

  def new_international_trade_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "trade",
      nickname: params[:nickname]
    )

    redirect_to edit_form_url(form_answer)
  end

  def new_sustainable_development_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "development",
      nickname: params[:nickname]
    )

    redirect_to edit_form_url(form_answer)
  end

  def new_enterprise_promotion_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "promotion",
      nickname: params[:nickname],
      document: {
        email: current_user.email,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        phone: current_user.phone_number,
        title: current_user.title
    })
    redirect_to edit_form_url(form_answer)
  end

  def edit_form
    if @form_answer.eligible?
      queen_award_holder = if @form_answer.promotion?
        @form_answer.eligibility.nominee_is_qae_ep_award_holder? ? "yes" : "no"
      else
        current_account.basic_eligibility.current_holder? ? "yes" : "no"
      end

      @form_answer.document = @form_answer.document.merge(queen_award_holder: queen_award_holder)
      @form_answer.save!
      @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
      render template: "qae_form/show"
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def submit_form
    doc = params[:form]
    @form_answer.document = serialize_doc(doc)

    @form_answer.submitted = true
    submitted_was_changed = @form_answer.submitted_changed?

    if @form_answer.save! && submitted_was_changed
      @form_answer.state_machine.submit
      Notifiers::Submission::SuccessNotifier.new(@form_answer).run
    end

    redirect_to submit_confirm_url(@form_answer)
  end

  def submit_confirm
    render template: "qae_form/confirm"
  end

  def autosave
    @form_answer.document = serialize_doc(params[:form])
    @form_answer.save!
    render json: {progress: @form_answer.fill_progress}
  end

  def add_attachment
    attachment_params = params[:form]
    attachment_params.merge!(form_answer_id: @form_answer.id)

    attachment_params.merge!(original_filename: attachment_params[:file].original_filename) if attachment_params[:file].respond_to?(:original_filename)

    attachment_params = attachment_params.permit(:original_filename, :file, :description, :link, :form_answer_id)

    @attachment = FormAnswerAttachment.new(attachment_params)
    @attachment.attachable = current_user
    @attachment.save!

    render json: @attachment, status: :created
  end

  private

  ## TODO: maybe we switch to JSON instead of hstore
  def serialize_doc doc
    result = {}
    doc.each do |(k, v)|
      if v.is_a?(Hash)
        if doc[k]["array"] == "true"
          v.values.each do |value|
            result[k] ||= []

            if value.is_a?(Hash)
              result[k] << value.to_json
            end
          end
        else
          result[k] = v.to_json
        end
      else
        result[k] = v
      end
    end

    result
  end

  def set_form_answer
    @form_answer = current_user.account.form_answers.find(params[:id])
    @attachments = @form_answer.form_answer_attachments.inject({}) do |r, attachment|
      r[attachment.id] = attachment
      r
    end
  end

  def check_trade_count_limit
    if current_account.has_trade_award_in_this_year?
      redirect_to dashboard_url, flash: {
        alert: "You can not submit more than one trade form per year"
      }
    end
  end
end
