require "rails_helper"

include Warden::Test::Helpers

describe "Assessors Progress Reports CSV" do
  let!(:first_assessor) { create(:assessor, :regular_for_trade) }
  let!(:second_assessor) { create(:assessor, :regular_for_trade) }

  let(:positions) do
    {
      primary: 0,
      secondary: 1,
      moderated: 2,
      case_summary: 4,
    }
  end

  before do
    #
    # 1 assessor
    #
    # Creating of:
    #
    # - 2 submitted primary assessments
    # - 3 submitted secondary assessments
    # - 1 submitted case summary assessments
    #
    # - 1 primary not submitted assessment
    # - 2 secondary not submitted assessment
    # - 1 case_summary not submitted assessment
    #

    [
      [2, "primary", true],
      [3, "secondary", true],
      [1, "case_summary", true],
      [1, "primary", false],
      [2, "secondary", false],
      [1, "case_summary", false],
    ].each do |entry|
      build_entry!(entry, first_assessor)
    end

    #
    # Creating 2 feedbacks
    # - 1 submitted, another not
    #
    create(:feedback, authorable: first_assessor, submitted: true)
    create(:feedback, authorable: first_assessor, submitted: false)

    #
    # 2 assessor
    #
    # Creating of:
    #
    # - 1 submitted primary assessments
    # - 2 submitted secondary assessments
    # - 3 submitted case summary assessments
    #
    # - 3 primary not submitted assessment
    # - 2 secondary not submitted assessment
    # - 1 case_summary not submitted assessment
    #

    [
      [1, "primary", true],
      [2, "secondary", true],
      [3, "case_summary", true],
      [3, "primary", false],
      [2, "secondary", false],
      [1, "case_summary", false],
    ].each do |entry|
      build_entry!(entry, second_assessor)
    end

    #
    # Creating 3 feedbacks
    # - 3 submitted, third not
    #
    2.times do
      create(:feedback, authorable: second_assessor, submitted: true)
    end
    create(:feedback, authorable: second_assessor, submitted: false)
  end

  let(:data) do
    Reports::DataPickers::AssessorProgressPicker.new(
      AwardYear.current,
      "trade",
    ).results
  end

  #
  # Data should be returned for following:
  #
  # "Assessor ID",
  # "Assessor Name",
  # "Assessor Email",
  # "Primary Assigned",
  # "Primary Assessed",
  # "Primary Case Summary",
  # "Primary Feedback",
  # "Secondary Assigned",
  # "Secondary Assessed",
  # "Total Assigned",
  # "Total Assessed"

  let(:expected_first_entry_data) do
    [first_assessor.id, first_assessor.full_name, first_assessor.email, 3, 2, 1, 1, 5, 3, 8, 5]
  end

  let(:expected_second_entry_data) do
    [second_assessor.id, second_assessor.full_name, second_assessor.email, 4, 1, 3, 2, 4, 2, 8, 3]
  end

  it "should render proper data" do
    expect(data[0]).to be_eql expected_first_entry_data
    expect(data[1]).to be_eql expected_second_entry_data
  end

  private

  def build_entry!(entry, assessor)
    entry[0].times do
      f = create(:form_answer, :submitted, :trade)

      assessment = AssessorAssignment.new(
        position: positions[entry[1].to_sym],
        assessor_id: assessor.id,
        form_answer_id: f.id,
      )

      assessment.submitted_at = Time.now if entry[2].present?

      assessment.save!(validate: false)
    end
  end
end
