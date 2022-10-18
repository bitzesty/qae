module FiguresAuthorisationCheck
  extend ActiveSupport::Concern

  included do
    before_action :check_if_figures_needed
  end

  private

  def check_if_figures_needed
    if form_answer.requires_vocf? || !form_answer.provided_estimates? || form_answer.shortlisted_documents_wrapper.try(:submitted?)
      redirect_to dashboard_url
    end
  end
end
