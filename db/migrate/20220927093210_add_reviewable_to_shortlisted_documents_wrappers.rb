class AddReviewableToShortlistedDocumentsWrappers < ActiveRecord::Migration[6.1]
  def change
    add_column :shortlisted_documents_wrappers, :status, :string
    add_column :shortlisted_documents_wrappers, :reviewable_type, :string
    add_column :shortlisted_documents_wrappers, :reviewable_id, :integer
    add_column :shortlisted_documents_wrappers, :reviewed_at, :datetime
    add_column :shortlisted_documents_wrappers, :changes_description, :text
  end
end
