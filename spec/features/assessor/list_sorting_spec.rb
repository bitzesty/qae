require "rails_helper"
include Warden::Test::Helpers

describe "Form answer list sorting", js: true do
  let!(:subject) { create(:assessor, :lead_for_all) }

  before do
    3.times do |i|
      create :form_answer,
        :trade,
        document: { company_name: "#{i}" },
        urn: "KAO-#{i}",
        state: "assessment_in_progress"
    end

    login_as(subject, scope: :assessor)
    visit assessor_form_answers_path
  end

  it_behaves_like "form answers table sorting"
end
