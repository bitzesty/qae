# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "#create" do
    it "creates an autosave token for an admin" do
      admin = Admin.create!(
        email: "john@example.com",
        first_name: "John",
        last_name: "Smith",
        password: "^#ur9EkLm@1W",
        password_confirmation: "^#ur9EkLm@1W"
      )

      expect(admin.autosave_token).not_to be nil
    end
  end
end
