# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompanyRegistrationNumberValidator do
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
      expect(CompanyRegistrationNumberValidator.valid?(registration_number)).to be_truthy
    end
  end

  it "should validate invalid registration number" do
    %w[
      012345678
      AB123456
      XXXXXXXX
    ].each do |registration_number|
      expect(CompanyRegistrationNumberValidator.valid?(registration_number)).to be_falsey
    end
  end
end
