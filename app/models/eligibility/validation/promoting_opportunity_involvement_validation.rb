class Eligibility::Validation::PromotingOpportunityInvolvementValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && eligibility.promoting_opportunity_involvement != "organisation_core_activity"
  end
end
