require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download an application PDF", %q{
As an Admin
I want to Print/download an application's feedback as a pdf
So that I can print and review application's feedback
} do

  let!(:admin) { create(:admin) }
  let!(:user) { create :user }

  before do
    login_admin(admin)
  end

  describe "International Trade Award" do
    let!(:form_answer) do
      create :form_answer, :trade,
                           :submitted,
                           user: user
    end

    include_context "admin application feedback pdf download"
  end

  describe "Innovation Award" do
    let!(:form_answer) do
      create :form_answer, :innovation,
                           :submitted,
                           user: user
    end

    include_context "admin application feedback pdf download"
  end

  describe "Sustainable Development Award" do
    let!(:form_answer) do
      create :form_answer, :development,
                           :submitted,
                           user: user
    end

    include_context "admin application feedback pdf download"
  end
end
