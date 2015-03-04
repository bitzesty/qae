require 'rails_helper'

RSpec.describe SupportLetterAttachment, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:form_answer) }
  end

  describe "validations" do
    %w(user form_answer attachment).each do |field_name|
      it { should validate_presence_of field_name }
    end

    describe "file size validation" do
      let!(:user) { create(:user) }
      let!(:form_answer) { create(:form_answer, user: user) }
    end
  end
end

