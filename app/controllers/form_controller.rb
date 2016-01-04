require "qae_2014_forms"

class FormController < ApplicationController
  before_action :authenticate_user!, :check_account_completion, :check_deadlines
  before_action :set_form_answer, :except => [:new_innovation_form, :new_international_trade_form, :new_sustainable_development_form, :new_enterprise_promotion_form]
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy,
    :submit_confirm, :save, :add_attachment
  ]
  before_action :get_collaborators, only: [
    :submit_confirm
  ]
  before_action :check_if_deadline_ended!, only: [:update, :save, :add_attachment]
  before_action :check_trade_count_limit, only: :new_international_trade_form
  before_action do
    allow_assessor_access!(@form_answer)
  end

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

  expose(:original_form_answer) do
    @form_answer.original_form_answer
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
    # TODO:
    # for now we will display always latest version of form
    # in future would be special button for this
    # @form_answer = original_form_answer if admin_in_read_only_mode?
    if @form_answer.eligible?
      if params[:step] == "letters-of-support"
        redirect_to form_form_answer_supporters_path(@form_answer)
        return
      elsif params[:step] == "add-website-address-documents"
        redirect_to form_form_answer_form_attachments_url(@form_answer)
        return
      elsif params[:step] == "nominee-background"
        redirect_to form_form_answer_positions_url(@form_answer)
        return
      end

      queen_award_holder = if @form_answer.promotion?
        @form_answer.eligibility.nominee_is_qae_ep_award_holder.presence || "no"
      else
        current_account.basic_eligibility.current_holder.presence || "no"
      end

      if @form_answer.document["queen_award_holder"].blank?
        holder = if @form_answer.trade?
          eligibility_holder = @form_answer.trade_eligibility.current_holder_of_qae_for_trade?
          eligibility_holder ? "yes" : "no"
        else
          queen_award_holder
        end

        @form_answer.document = @form_answer.document.merge(queen_award_holder: holder)

        if holder == "yes" && @form_answer.trade?
          eligibility_holder = @form_answer.trade_eligibility.current_holder_of_qae_for_trade?
          year = @form_answer.trade_eligibility.qae_for_trade_award_year
          if year.to_i < AwardYear.current.year - 5 || !eligibility_holder
            @form_answer.document = @form_answer.document.merge(queen_award_holder: "no")
          else
            details = [{ category: "international_trade", year: year.to_s }]
            @form_answer.document = @form_answer.document.merge(queen_award_holder_details: details)
          end
        end
      end

      @form_answer.save unless admin_in_read_only_mode?
      @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
      gon.push base_year: @form_answer.award_year.year - 1

      render template: "qae_form/show"
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def save
    @form_answer.document = prepare_doc if params[:form].present?
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))

    redirected = params[:next_action] == "redirect"
    submitted = params[:submit] == "true" && !redirected

    respond_to do |format|
      format.html do
        redirected = params[:next_action] == "redirect"

        if submitted
          @form_answer.submitted = true
        end

        submitted_was_changed = @form_answer.submitted_changed?
        @form_answer.current_step = params[:current_step] || @form.steps.first.title.parameterize

        if params[:form].present? && @form_answer.eligible? && (saved = @form_answer.save)
          if submitted_was_changed
            @form_answer.state_machine.submit(current_user)
            FormAnswerUserSubmissionService.new(@form_answer).perform
          end
        end

        if redirected
          redirect_to dashboard_url
        else
          if submitted && saved
            redirect_to submit_confirm_url(@form_answer)
          else
            if saved
              params[:next_step] ||= @form.steps[1].title.parameterize
              redirect_to edit_form_url(@form_answer, step: params[:next_step])
            else
              params[:step] = @form_answer.steps_with_errors.try(:first)
              # avoid redirecting to supporters page
              if !params[:step] || params[:step] == "letters-of-support"
                params[:step] = @form.steps.first.title.parameterize
              end

              render template: "qae_form/show"
            end
          end
        end
      end

      format.js do
        if submitted
          @form_answer.submitted = true
        end

        submitted_was_changed = @form_answer.submitted_changed?

        if params[:form].present? && @form_answer.eligible? && @form_answer.save
          if submitted_was_changed
            @form_answer.state_machine.submit(current_user)
            FormAnswerUserSubmissionService.new(@form_answer).perform
          end
        end

        render json: { progress: @form_answer.fill_progress }
      end
    end
  end

  def submit_confirm
    render template: "qae_form/confirm"
  end

  def add_attachment
    FormAnswer.transaction do
      attachment_params = params[:form]
      attachment_params.merge!(form_answer_id: @form_answer.id)

      attachment_params.merge!(original_filename: attachment_params[:file].original_filename) if attachment_params[:file].respond_to?(:original_filename)

      attachment_params = attachment_params.permit(:original_filename, :file, :description, :link, :form_answer_id)

      @attachment = FormAnswerAttachment.new(attachment_params)
      @attachment.attachable = current_user
      @attachment.question_key = params[:question_key] if params[:question_key].present?

      if @attachment.question_key == "org_chart"
        @form_answer.form_answer_attachments.where(question_key: "org_chart").destroy_all
      end

      if @attachment.save
        @form_answer.document[@attachment.question_key]  ||= {}
        attachments_hash = @form_answer.document[@attachment.question_key]
        index = next_index(attachments_hash)
        attachments_hash[index] = { file: @attachment.id }
        @form_answer.save!

        # text/plain content type is needed for jquery.fileupload
        render json: @attachment, status: :created, content_type: "text/plain"
      else
        render json: { errors: humanized_upload_errors }.to_json,
               status: :unprocessable_entity
      end
    end
  end

  def get_collaborators
    @collaborators = current_user.account.collaborators_without(current_user)
  end

  private

  def next_index(hash)
    return 0 if hash.empty?
    return hash.keys.sort.last.to_i + 1
  end

  def updating_step
    @form_answer.award_form.steps.detect do |s|
      s.title.parameterize == params[:current_step_id].gsub("step-", "")
    end.decorate
  end

  def prepare_doc
    allowed_params = updating_step.allowed_questions_params_list(params[:form])
    @form_answer.document.merge(prepare_doc_structures(allowed_params))
  end

  def prepare_doc_structures doc
    result = {}

    doc.each do |(k, v)|
      if v.is_a?(Hash)
        if doc[k]["array"] == "true"
          v.values.each do |value|
            result[k] ||= []

            if value.is_a?(Hash)
              result[k] << value
            end
          end
        else
          result[k] = v
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
  end

  def submit_action?
    params[:submit] == "true"
  end

  def check_if_deadline_ended!
    if current_form_submission_ended?
      if request.xhr?
        render json: { error: "ERROR: Form can't be updated as submission ended!" }
      else
        redirect_to dashboard_path,
                    notice: "Form can't be updated as submission ended!"
      end

      return false
    end
  end

  def humanized_upload_errors
    @attachment.errors
               .full_messages
               .reject { |m| m == "File This field cannot be blank" }
               .join(", ")
               .gsub("File ", "")
  end
end
