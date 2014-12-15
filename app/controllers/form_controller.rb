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
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'innovation')
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
      @form = @form_answer.award_form.decorate(answers: (@form_answer.document || {}))
      render template: 'qae_form/show'
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def submit_form
    path_params = request.path_parameters
    doc = params.except(*path_params.keys)
    @form_answer.document = doc

    @form_answer.submitted = true
    if @form_answer.save! && @form_answer.submitted_changed?
      Users::SubmissionMailer.delay.success(@form_answer.id)
    end

    redirect_to submit_confirm_url(@form_answer)
  end

  def submit_confirm
    load_eligibilities
    render template: 'qae_form/confirm'
  end

  def autosave
    @form_answer.document = params[:form]
    @form_answer.save!
    render :nothing => true
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

  def set_form_answer
    @form_answer = FormAnswer.for_account(current_user.account).find(params[:id])
    @attachments = @form_answer.form_answer_attachment.inject({}) do |r, attachment|
        r[attachment.id] = attachment
        r
      end
  end

end
