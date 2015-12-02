require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download original pdf of application at the deadline", %q{
As an Admin
I want to download original PDF of application at the deadline
So that I can see original application data was at the deadline moment
} do

  let!(:admin) { create(:admin) }

  let(:target_url) do
    admin_form_answer_path(form_answer)
  end

  let(:pdf_url) do
    original_pdf_before_deadline_admin_form_answer_url(form_answer, format: :pdf)
  end

  before do
    login_admin(admin)
  end

  it_behaves_like "download original pdf before deadline ends"
end
