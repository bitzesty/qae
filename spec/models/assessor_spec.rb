# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assessor, type: :model do
  describe "#create" do
    it "creates an autosave token for an assessor" do
      assessor = Assessor.create!(
        email: "john-assessor@example.com",
        first_name: "John",
        last_name: "Smith",
        password: "^#ur9EkLm@1W+OaDvg",
        password_confirmation: "^#ur9EkLm@1W+OaDvg",
      )

      expect(assessor.autosave_token).not_to be nil
    end
  end

  describe "#lead?" do
    let(:form_answer) { build(:form_answer, :trade) }
    context "lead" do
      let(:assessor) { build(:assessor, :lead_for_trade) }
      it "is true" do
        expect(assessor.lead?(form_answer)).to eq(true)
      end
    end
    context "regular (not assigned)" do
      let(:assessor) { build(:assessor, :regular_for_trade) }
      it "is false" do
        expect(assessor.lead?(form_answer)).to eq(false)
      end
    end
  end

  describe "#soft_delete!" do
    it "should set deleted" do
      assessor = create(:assessor)
      assessor.soft_delete!
      expect(assessor.deleted.present?).to be_truthy
    end
  end

  describe "scopes" do
    it ".trade_lead should filter correctly" do
      expect(Assessor.where(trade_role: "lead").to_sql).to eq Assessor.trade_lead.to_sql
    end
    it ".trade_regular should filter correctly" do
      expect(Assessor.where(trade_role: "regular").to_sql).to eq Assessor.trade_regular.to_sql
    end

    context ".leads_for" do
      it "should return correct results" do
        expect(Assessor.where(trade_role: "lead").to_sql).to eq Assessor.leads_for("trade").to_sql
      end
    end

    context ".roles" do
      it "should return roles" do
        expect(Assessor.roles).to eq [["Not Assigned", nil], ["Lead Assessor", "lead"], ["Assessor", "regular"]]
      end
    end
  end

  describe "reports" do
    it "CasesStatusReport should return csv" do
      year = create(:award_year)
      assessor = create(:assessor, :regular_for_trade)
      report = Reports::CasesStatusReport.new(year).build_for_lead(assessor)

      expect(report).to_not be_empty
    end

    it "AssessorsProgressReport should return csv" do
      year = create(:award_year)
      assessor = create(:assessor, :regular_for_trade)
      target_csv = "\"Assessor ID\",\"Assessor Name\",\"Assessor Email\",\"Primary Assigned\",\"Primary Assessed\",\"Primary Case Summary\",\"Primary Feedback\",\"Secondary Assigned\",\"Secondary Assessed\",\"Total Assigned\",\"Total Assessed\"\n\"#{assessor.id}\",\"John Doe\",\"#{assessor.email}\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\"\n"
      expect(Reports::AssessorsProgressReport.new(year, "trade").build).to eq target_csv
    end

    it "AssessorReport should trigger correctly" do
      year = create(:award_year)
      assessor = create(:assessor, :regular_for_trade)

      expect(Reports::CasesStatusReport).to receive_message_chain(:new, :build_for_lead)
      Reports::AssessorReport.new("cases-status", year, assessor).as_csv

      expect(Reports::AssessorsProgressReport).to receive_message_chain(:new, :build)
      Reports::AssessorReport.new("assessors-progress", year, assessor, category: "trade").as_csv

      expect{ Reports::AssessorReport.new("assessors-progress", year, assessor, category: "invalid").as_csv }.to raise_error(ArgumentError)
    end
  end

  describe "#lead_roles" do
    it "should return lead_roles" do
      expect(Assessor.new.lead_roles).to eq []
    end
  end

  context "devise mailers" do
    let(:user) { create(:assessor) }

    include_context "devise mailers instructions"
  end

  describe "has_access_to_award_type?" do
    it "returns true for an assessor that has a regular/lead role for award type" do
      assessor = build(:assessor, :regular_for_trade, :lead_for_innovation)
      expect(assessor.has_access_to_award_type?("trade")).to eq(true)
      expect(assessor.has_access_to_award_type?("innovation")).to eq(true)
      expect(assessor.has_access_to_award_type?("mobility")).to eq(false)
      expect(assessor.has_access_to_award_type?("promotion")).to eq(false)
      expect(assessor.has_access_to_award_type?("development")).to eq(false)
    end
  end
end
