class Users::AuditCertificatesController < Users::BaseController
  before_action :check_if_vocf_is_required!
  before_action :check_if_audit_certificate_already_exist!, only: [:create]

  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end

  expose(:pdf_data) do
    form_answer.decorate.pdf_audit_certificate_generator
  end

  expose(:audit_certificate) do
    form_answer.audit_certificate
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        log_event
        send_data pdf_data.render,
                  filename: "External_Accountants_Report_#{form_answer.urn}_#{form_answer.decorate.pdf_filename}",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

  def create
    self.audit_certificate = form_answer.build_audit_certificate(audit_certificate_params)

    if saved = audit_certificate.save
      log_event
      if form_answer.assessors.primary.present?
        Assessors::GeneralMailer.audit_certificate_uploaded(form_answer.id).deliver_later!
      end

      Users::AuditCertificateMailer.notify(form_answer.id, current_user.id).deliver_later!
    end

    respond_to do |format|
      format.html do
        if saved
          redirect_to users_form_answer_audit_certificate_url(form_answer),
                      notice: "Verification of Commercial Figures successfully uploaded!"
        else
          render :show
        end
      end

      format.json do
        if saved
          render json: audit_certificate,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    log_event if audit_certificate.destroy
    redirect_to users_form_answer_audit_certificate_url(form_answer)
  end

  private

  def action_type
    case action_name
    when "show"
      "audit_certificate_downloaded"
    when "create"
      "audit_certificate_uploaded"
    when "destroy"
      "audit_certificate_destroyed"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def audit_certificate_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:audit_certificate].blank?
      params.merge!(
        audit_certificate: {
          attachment: ""
        }
      )
    end

    params.require(:audit_certificate).permit(:attachment)
  end

  def humanized_errors
    audit_certificate.errors
                     .full_messages
                     .reject { |m| m == "Attachment This field cannot be blank" }
                     .join(", ")
                     .gsub("Attachment ", "")
  end

  def check_if_audit_certificate_already_exist!
    if audit_certificate.present? && audit_certificate.persisted?
      head :ok
      return
    end
  end

  def check_if_vocf_is_required!
    unless form_answer.requires_vocf?
      redirect_to dashboard_url
      return
    end
  end
end
