require "rails_helper"

RSpec.describe SupportLetterAttachment, type: :model do
  describe "validations" do
    %w[user form_answer attachment].each do |field_name|
      it { should validate_presence_of field_name }
    end

    describe "file size validation" do
      let!(:user) { create(:user) }
      let!(:form_answer) { create(:form_answer, user:) }

      let(:too_big_file) do
        Rack::Test::UploadedFile.new(
          File.join(
            Rails.root, "spec", "support", "file_samples", "photo_with_size_more_than_5MB.jpg"
          ),
        )
      end
      let(:file_with_wrong_extension) do
        Rack::Test::UploadedFile.new(
          File.join(
            Rails.root, "spec", "support", "file_samples", "simple_txt_sample.log"
          ),
        )
      end
      let(:normal_file) do
        Rack::Test::UploadedFile.new(
          File.join(
            Rails.root, "spec", "support", "file_samples", "photo_with_size_less_than_5MB.jpg"
          ),
        )
      end

      let(:attachment_with_too_big_file) do
        build :support_letter_attachment, form_answer:,
                                          user:,
                                          attachment: too_big_file
      end
      let(:attachment_with_wrong_extension_file) do
        build :support_letter_attachment, form_answer:,
                                          user:,
                                          attachment: file_with_wrong_extension
      end
      let(:attachment_with_normal_file) do
        build :support_letter_attachment, form_answer:,
                                          user:,
                                          attachment: normal_file
      end

      it "should allow to upload 5MB file maximum" do
        expect(attachment_with_too_big_file.valid?).to be_falsey
        expect(attachment_with_too_big_file.errors.full_messages).to include(
          "Attachment is too big (should be at most 5 MB)",
        )
      end

      it "should allow to upload files with allowed extensions" do
        expect(attachment_with_wrong_extension_file.valid?).to be_falsey
        expect(attachment_with_wrong_extension_file.errors.full_messages).to include(
          "Attachment You are not allowed to upload \"log\" files, allowed types: #{FileUploader.new.extension_whitelist.join(", ")}",
        )
      end

      it "should allow to upload proper files" do
        expect(attachment_with_normal_file.valid?).to be_truthy
      end
    end
  end
end
