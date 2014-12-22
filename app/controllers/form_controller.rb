require 'qae_2014_forms'

class FormController < ApplicationController
  before_filter :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  before_filter :set_form_answer, :except => [:new_innovation_form, :new_international_trade_form, :new_sustainable_development_form]
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy,
    :submit_form,
    :submit_confirm,
    :autosave
  ]

  def new_innovation_form
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'innovation', document: {
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
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'trade')
    redirect_to edit_form_url(form_answer)
  end

  def new_sustainable_development_form
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'development')
    redirect_to edit_form_url(form_answer)
  end

  def edit_form
    if @form_answer.eligible?
      @form_answer.document = @form_answer.document.merge(queen_award_holder: current_user.basic_eligibility.current_holder == "true" ? 'yes' : 'no')
      @form_answer.save!
      @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document || {}))
      render template: 'qae_form/show'
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def submit_form
    path_params = request.path_parameters
    doc = params[:form]
    @form_answer.document = serialize_doc(doc)

    @form_answer.submitted = true
    if @form_answer.save! && @form_answer.submitted_changed?
      Submission::SuccessNotifier.new(@form_answer).run
    end

    redirect_to submit_confirm_url(@form_answer)
  end

  def submit_confirm
    load_eligibilities
    render template: 'qae_form/confirm'
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

    @attachment = FormAnswerAttachment.create!(attachment_params)

    render json: @attachment, status: :created
  end

  private

  ## TODO: maybe we switch to JSON instead of hstore
  def serialize_doc doc
    result = {}
    doc.each do |(k, v)|
      if v.is_a?(Hash)
        result[k] = v.to_json
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
end
