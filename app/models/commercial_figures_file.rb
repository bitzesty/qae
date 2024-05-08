class CommercialFiguresFile < ActiveRecord::Base
  include ShortlistedDocument

  validates :attachment, presence: true,
    on: :create,
    file_size: {
      maximum: 5.megabytes.to_i
    }

  validates :form_answer_id, uniqueness: true,
    presence: true

  belongs_to :shortlisted_documents_wrapper, optional: true
end
