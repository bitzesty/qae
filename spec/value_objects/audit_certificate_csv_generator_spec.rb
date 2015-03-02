require 'rails_helper'

describe AuditCertificateCsvGenerator do
  let(:audit_certificate_answers_sample) {
    FactoryGirl.generate(:audit_certificate_answers_sample)
  }

  let!(:user) do
    FactoryGirl.create :user
  end

  let(:form_answer) do
    FactoryGirl.create :form_answer, :submitted, :innovation,
      user: user,
      document: audit_certificate_answers_sample
  end

  let(:csv_generator) do
    AuditCertificateCsvGenerator.new(form_answer)
  end

  before do
    allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    form_answer
  end

  describe "#run" do
    let(:data) { csv_generator.run }

    it "should return proper CSV data in accordance with form financial data" do
      Rails.logger.info "data: #{data} class: #{data.class}"
      expect(data).not_to be_nil

      expected_data_entries = [
        "Innovation Award 2015,Bitzesty",
        "Financial year dates,01/01/2011,01/01/2012,1/1/2013,01/01/2014,02/1/2015",
        "Number of people employed,10,20,30,40,50",
        "Total turnover,100000,100000,100000,100000,100000",
        "Exports,10000,10000,10000,10000,10000",
        "Net profit after tax but before dividends,20000,20000,20000,20000,20000",
        "Total net assets,30000,30000,30000,30000,30000",
        "Number of innovative units/contracts sold,5,6,7,8,9",
        "Sales of innovative product/service,10,11,12,13,14",
        "Sales exports,10,10,10,10,10",
        "Sales royalties or licenses,10,10,10,10,10",
        "Average unit selling price/contract value,10,10,10,10,10",
        "Direct cost of a single unit/contract,10,10,10,10,10"
      ]

      expected_data_entries.each do |entry|
        expect(data).to include(entry)
      end
    end
  end
end
