class CaseSummaryHardCopyPdf < ActiveRecord::Base
  belongs_to :form_answer

  mount_uploader :attachment, FormAnswerPdfVersionUploader
end
