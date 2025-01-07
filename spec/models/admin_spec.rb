# frozen_string_literal: true

require "rails_helper"

describe Admin, type: :model do
  describe "#create" do
    let(:admin) { Admin.create!(email: "john@example.com", first_name: "John", last_name: "Smith") }

    it "creates an autosave token for an admin" do
      expect(admin.autosave_token).not_to be nil
    end
  end

  describe "lead?" do
    it "should return true" do
      expect(Admin.new.lead?).to be_truthy
    end
  end

  describe "primary?" do
    it "should return true" do
      expect(Admin.new.primary?).to be_truthy
    end
  end

  describe "soft_delete!" do
    let(:admin) { create(:admin) }

    it "should set deleted" do
      expect { admin.soft_delete! }.to change { admin.deleted.present? }.from(false).to(true)
    end
  end
end
