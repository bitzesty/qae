# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "#create" do
    it "creates an autosave token for an admin" do
      admin = Admin.create!(
        email: "john@example.com",
        first_name: "John",
        last_name: "Smith",
        password: "^#ur9EkLm@1W+OaDvg",
        password_confirmation: "^#ur9EkLm@1W+OaDvg"
      )

      expect(admin.autosave_token).not_to be nil
    end
  end

  describe "lead?" do
    it 'should return true' do
      expect(Admin.new.lead?).to be_truthy
    end
  end

  describe "primary?" do
    it 'should return true' do
      expect(Admin.new.primary?).to be_truthy
    end
  end

  describe "soft_delete!" do
    it 'should set deleted' do
      admin = create(:admin)
      admin.soft_delete!
      expect(admin.deleted.present?).to be_truthy
    end
  end

  context "devise mailers" do
    let(:user) { create(:admin) }

    include_context "devise mailers instructions"
  end
end
