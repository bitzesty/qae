require "qae_2014_forms"

class FormController < ApplicationController
  before_action :authenticate_user!, :check_account_completion, :check_deadlines
  before_action :set_form_answer, :except => [:new_innovation_form, :new_international_trade_form, :new_sustainable_development_form, :new_enterprise_promotion_form]
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy,
    :submit_confirm
  ]
  before_action :get_collaborators, only: [
    :submit_confirm
  ]
  before_action :require_to_be_account_admin!, only: :submit_confirm
  before_action :check_trade_count_limit, only: :new_international_trade_form

  expose(:support_letter_attachments) do
    @form_answer.support_letter_attachments.inject({}) do |r, attachment|
      r[attachment.id] = attachment
      r
    end
  end

  expose(:all_form_questions) do
    @form_answer.award_form.steps.map(&:questions).flatten
  end

  expose(:questions_with_references) do
    all_form_questions.select do |q|
      !q.is_a?(QAEFormBuilder::HeaderQuestion) &&
      (q.ref.present? || q.sub_ref.present?)
    end
  end

  def new_innovation_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "innovation",
      nickname: nickname,
      document: {
        company_name: current_user.company_name
    })
    redirect_to edit_form_url(form_answer)
  end

  def new_international_trade_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "trade",
      nickname: nickname,
      document: {
        company_name: current_user.company_name
    })

    redirect_to edit_form_url(form_answer)
  end

  def new_sustainable_development_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "development",
      nickname: nickname,
      document: {
        company_name: current_user.company_name
    })

    redirect_to edit_form_url(form_answer)
  end

  def new_enterprise_promotion_form
    form_answer = FormAnswer.create!(
      user: current_user,
      account: current_user.account,
      award_type: "promotion",
      nickname: nickname,
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
      if params[:step] == "letters-of-support"
        redirect_to form_form_answer_supporters_path(@form_answer)
        return
      end

      queen_award_holder = if @form_answer.promotion?
        @form_answer.eligibility.nominee_is_qae_ep_award_holder? ? "yes" : "no"
      else
        current_account.basic_eligibility.current_holder? ? "yes" : "no"
      end

      if @form_answer.document["queen_award_holder"].blank?
        @form_answer.document = @form_answer.document.merge(queen_award_holder: queen_award_holder)
      end

      @form_answer.save!
      @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
      render template: "qae_form/show"
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def save
    @form_answer.document = serialize_doc(params[:form])
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))

    redirected = params[:next_action] == "redirect"
    submitted = params[:submit] == "true" && !redirected

    if submitted
      @form_answer.submitted = true
    end

    submitted_was_changed = @form_answer.submitted_changed?

    if @form_answer.eligible? && @form_answer.save
      if submitted_was_changed
        @form_answer.state_machine.submit(current_user)
        Notifiers::Submission::SuccessNotifier.new(@form_answer).run
      end
    end

    respond_to do |format|
      format.html do
        if redirected
          redirect_to dashboard_url
        else
          if submitted
            redirect_to submit_confirm_url(@form_answer)
          else
            params[:next_step] ||= @form.steps[1].title.parameterize
            redirect_to edit_form_url(@form_answer.id, step: params[:next_step])
          end
        end
      end

      format.js do
        render json: { progress: @form_answer.fill_progress }
      end
    end
  end

  def submit_confirm
    render template: "qae_form/confirm"
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

  def get_collaborators
    @collaborators = current_user.account.collaborators_without(current_user)
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

  def nickname
    params[:nickname].presence
  end

  def check_deadlines
    return if admin_in_read_only_mode?

    unless submission_started?
      flash.alert = "Sorry, submission is still closed"
      redirect_to dashboard_url
    end

    if submission_ended?
      flash.alert = "Sorry, submission has already ended"
      redirect_to dashboard_url
    end
  end
end
