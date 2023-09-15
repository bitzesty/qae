class CaseSummaryHardCopyPdf < ApplicationRecord
  belongs_to :form_answer, optional: true

  mount_uploader :file, FormAnswerPdfVersionUploader

  validates :form_answer,
            :file,
            :original_filename, presence: true
end
