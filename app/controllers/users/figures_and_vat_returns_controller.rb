class Users::FiguresAndVatReturnsController < Users::BaseController
  before_action :check_if_figures_already_exist!, only: [:create]

  def show
    @figures_form = form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper
    @figures_form.save! if !@figures_form.persisted?
  end

  def submit
    @figures_form = form_answer.shortlisted_documents_wrapper
    if @figures_form.submit

      if form_answer.assessors.primary.present?
        Assessors::GeneralMailer.vat_returns_submitted(form_answer.id).deliver_later!
      end

      Users::CommercialFiguresMailer.notify(form_answer.id, current_user.id).deliver_later!

      redirect_to dashboard_url
    else
      @figures_form.submitted_at = nil

      render :show
    end
  end

  private

  def action_type
    case action_name
    when "vat_returns"
    when "figures"
    when "destroy_vat_returns"
    when "destroy_figures"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def form_answer
    @form_answer ||= current_user.account.
                       form_answers.
                       find(params[:form_answer_id])
  end
end
