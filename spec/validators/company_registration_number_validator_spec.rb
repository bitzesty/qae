# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompanyRegistrationNumberValidator do
  def anonymous_class
    Class.new(ActiveRecord::Base) do
      self.table_name = "company_registration_number_validator_test"

      validates :registration_number, company_registration_number: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "temp")
      end
    end
  end

  before(:suite) do
    ActiveRecord::Base.connection.create_table :company_registration_number_validator_test do |t|
      t.string :registration_number
    end
  end

  it "should validate valid registration number" do
    %w[
      123456
      1234567
      01234567
      OC555555
      LP003139
      SC123456
      SO305443
      SL002900
      NI123456
      R0000284
      NC001306
      NL000107
    ].each do |registration_number|
      model = anonymous_class.new(registration_number: registration_number)
      expect(model).to be_valid
    end
  end

  it "should validate invalid registration number" do
    %w[
      012345678
      AB123456
      XXXXXXXX
    ].each do |registration_number|
      model = anonymous_class.new(registration_number: registration_number)
      expect(model).to be_invalid
    end
  end
end

