class VatReturnsFile < ActiveRecord::Base
  include ShortlistedDocument

  validates :attachment, presence: true,
                         on: :create,
                         file_size: {
                           maximum: 5.megabytes.to_i,
                         }

  belongs_to :shortlisted_documents_wrapper, optional: true

  after_destroy :unsubmit_if_needed

  private

  def unsubmit_if_needed
    return unless shortlisted_documents_wrapper.submitted?

    return unless shortlisted_documents_wrapper.vat_returns_files.count.zero?

    shortlisted_documents_wrapper.update_column(:submitted_at, nil)
  end
end
