class AggregatedAwardYearPdf < ActiveRecord::Base

  TYPES_OF_GENERATING_HARD_COPIES = %w(form_data case_summary feedback)
  TYPES = %w(case_summary feedback)

  belongs_to :award_year

  validates :award_year_id, uniqueness: { scope: [:award_category, :type] },
                            presence: true

  validates :award_category,
            :type, presence: true

  mount_uploader :file, FormAnswerPdfVersionUploader
end
