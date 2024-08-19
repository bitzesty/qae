class Eligibility::Validation::NotNoValidation < Eligibility::Validation::Base
  def valid?
    answer.present? && eligibility.do_you_file_company_tax_returns != "false"
  end
end
