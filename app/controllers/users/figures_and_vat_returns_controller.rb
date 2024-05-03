class Users::FiguresAndVatReturnsController < Users::BaseController
  include FiguresAuthorisationCheck

  def show
    @figures_form = form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper
    @figures_form.save! unless @figures_form.persisted?
  end

  def submit
    @figures_form = form_answer.shortlisted_documents_wrapper
    if @figures_form.submit

      Assessors::GeneralMailer.vat_returns_submitted(form_answer.id).deliver_later! if form_answer.assessors.primary.present?

      Users::CommercialFiguresMailer.notify(form_answer.id, current_user.id).deliver_later!

      redirect_to dashboard_url
    else
      @figures_form.submitted_at = nil

      render :show
    end
  end

  private

  def form_answer
    @form_answer ||= current_user.account
                       .form_answers
                       .find(params[:form_answer_id])
  end
end
