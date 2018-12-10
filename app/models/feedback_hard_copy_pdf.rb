class FeedbackHardCopyPdf < ApplicationRecord
  belongs_to :form_answer

  mount_uploader :file, FormAnswerPdfVersionUploader

  validates :form_answer,
            :file,
            :original_filename, presence: true
end
