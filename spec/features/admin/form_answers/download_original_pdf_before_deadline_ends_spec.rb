require "rails_helper"
include Warden::Test::Helpers

describe "Admin: Download original pdf of application at the deadline", %q{
As an Admin
I want to download original PDF of application at the deadline
So that I can see original application data was at the deadline moment
} do
  before do
    login_admin(create(:admin))

    update_current_submission_deadline
    form_answer.generate_pdf_version!
  end

  it_behaves_like "download original pdf before deadline ends"
end
