require 'rails_helper'

RSpec.describe Questionnaire, :type => :model do
  describe "validations" do
    [:overall_payment_rating, :security_rating, :payment_usability_rating].each do |field_name|
      it { should validate_presence_of field_name }
    end
  end

  describe "associations" do
    it { should belong_to(:form_answer) }
  end
end
