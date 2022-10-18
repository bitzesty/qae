class Users::FiguresAndVatReturnsController < Users::BaseController
  before_action :check_if_figures_needed

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

  def form_answer
    @form_answer ||= current_user.account.
                       form_answers.
                       find(params[:form_answer_id])
  end

  def check_if_figures_needed
    if form_answer.requires_vocf? || !form_answer.provided_estimates? || form_answer.shortlisted_documents_wrapper.try(:submitted?)
      redirect_to dashboard_url
    end
  end
end
