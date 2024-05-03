class AggregatedAwardYearPdf < ApplicationRecord
  TYPES = %w[case_summary feedback]

  belongs_to :award_year, optional: true

  validates :award_year_id, uniqueness: { scope: %i[award_category type_of_report sub_type] },
                            presence: true

  validates :file,
            :award_category,
            :type_of_report, presence: true

  mount_uploader :file, FormAnswerPdfVersionUploader
end
