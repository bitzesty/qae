require "rails_helper"
include Warden::Test::Helpers

describe "Form answer list sorting", js: true do
  let!(:subject) { create(:admin) }

  before do
    3.times do |i|
      create :form_answer,
             :trade,
             document: { company_name: "#{i}" },
             urn: "QAO-#{i}"
    end

    login_as(subject, scope: :admin)
    visit admin_form_answers_path
  end

  it_behaves_like "form answers table sorting"
end
