require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Admin submits appraisal form", %(
  As Admin
  I want to be able to edit, submit the appraisal form.
), js: true do
  let(:scope) { :admin }
  let(:subject) { create(:admin) }

  it_behaves_like "successful appraisal form edition"
end
