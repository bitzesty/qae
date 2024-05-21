require "rails_helper"
include Warden::Test::Helpers

describe "Admin: Download an application's case summaries PDF", %q{
As an Admin
I want to Print/download an application's case summaries as a pdf
So that I can print and review application's case summaries
} do
  let!(:admin) { create(:admin) }
  let!(:user) { create :user }

  before do
    login_admin(admin)
  end

  describe "International Trade Award" do
    let(:award_type) { :trade }
    include_context "admin application case summaries pdf download"
  end

  describe "Innovation Award" do
    let(:award_type) { :innovation }
    include_context "admin application case summaries pdf download"
  end

  describe "Sustainable Development Award" do
    let(:award_type) { :development }
    include_context "admin application case summaries pdf download"
  end

  describe "Promoting Opportunity Award" do
    let(:award_type) { :mobility }
    include_context "admin application case summaries pdf download"
  end
end
