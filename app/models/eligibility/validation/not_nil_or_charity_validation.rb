class Eligibility::Validation::NotNilOrCharityValidation < Eligibility::Validation::Base
  def valid?
    !answer.nil? || eligibility.organization_kind == 'charity'
  end
end
