require "rails_helper"

Warden.test_mode!

describe "As Lead Assessor I want to sort by assessors", js: true do
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    3.times do |i|
      form = create(:form_answer, :trade, state: "assessment_in_progress")
      assessor = create(:assessor, :lead_for_all, first_name: i.to_s)
      primary = form.assessor_assignments.primary
      primary.assessor_id = assessor.id
      primary.save!
    end
    login_as(assessor, scope: :assessor)
    visit assessor_form_answers_path
  end

  it "displays the forms based on the primary assessor name order" do
    expected_indices = %w[0 1 2]
    find("th.sortable.th-primary-name", text: "Primary Assessor").find("a").click

    expect(assessor_names).to eq(expected_indices)

    find("th.sortable.th-primary-name", text: "Primary Assessor").find("a").click

    expect(assessor_names).to eq(expected_indices.reverse)
  end
end

private

def assessor_names
  names = []
  within ".applications-table" do
    names = all("tbody tr").map do |tr|
      tr.find(".td-primary-name").text
      # tr.all("td")[5].text
    end
  end
  names.map { |name| name[0] }
end
