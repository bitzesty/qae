class Eligibility::Validation::OtherFocusValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && eligibility.promoting_opportunity_involvement == "Our main activity is focused on something else, but we have activities or initiatives that are positively supporting social mobility"
  end
end
