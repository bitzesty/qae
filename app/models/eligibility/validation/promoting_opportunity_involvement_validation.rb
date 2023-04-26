class Eligibility::Validation::PromotingOpportunityInvolvementValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && eligibility.promoting_opportunity_involvement != "D. We are an organisation whose core activity is to improve social mobility, and we are applying for this award on the basis of our core activity."
  end
end
