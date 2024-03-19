require "rails_helper"

describe Reports::Admin::AssessorJudgeAdminDataReport do
  let! (:admin) { create(:admin) }
  let! (:assessor) { create(:assessor, :lead_for_trade) }
  let! (:judge) { create(:judge, :innovation) }

  let(:output) { described_class.new().as_csv }
  it "creates the output with relevant data for Admins" do
    expect(output).to include(admin.id.to_s)
    expect(output).to include(admin.first_name)
    expect(output).to include(admin.last_name)
    expect(output).to include(admin.email)
    expect(output).to include("Admin")
    expect(output).to include(admin.created_at.to_s)
    expect(output).to include(admin.last_sign_in_at.to_s)
  end

  it "creates the output with relevant data for Assessors" do
    expect(output).to include(assessor.id.to_s)
    expect(output).to include(assessor.first_name)
    expect(output).to include(assessor.last_name)
    expect(output).to include(assessor.email)
    expect(output).to include(assessor.telephone_number.to_s)
    expect(output).to include(assessor.company.to_s)
    expect(output).to include("Assessor")
    expect(output).to include(assessor.created_at.to_s)
    expect(output).to include(assessor.last_sign_in_at.to_s)
    expect(output).to include("trade")
  end

  it "creates the output with relevant data for Judges" do
    expect(output).to include(judge.id.to_s)
    expect(output).to include(judge.first_name)
    expect(output).to include(judge.last_name)
    expect(output).to include(judge.email)
    expect(output).to include("Judge")
    expect(output).to include(judge.created_at.to_s)
    expect(output).to include(judge.last_sign_in_at.to_s)
    expect(output).to include("innovation")
  end
end
