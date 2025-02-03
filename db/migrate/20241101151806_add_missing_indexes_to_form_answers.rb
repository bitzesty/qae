class AddMissingIndexesToFormAnswers < ActiveRecord::Migration[6.1]
  def change
    # Core filtering fields
    add_index :form_answers, :state # For filtering by state
    add_index :form_answers, :award_type # For filtering by award type
    
    # Search fields
    add_index :form_answers, :company_or_nominee_name # For company name search
    add_index :form_answers, :urn # For reference number search
    
    # Status fields
    add_index :form_answers, :submitted # For submission status filtering
    add_index :form_answers, :submitted_at # For sorting by submission date
    
    # Assessor related fields
    add_index :form_answers, [:primary_assessor_id, :secondary_assessor_id], 
              name: 'index_form_answers_on_assessors' # For assessor filtering
              
    # Compound index for common filter combinations
    add_index :form_answers, [:state, :award_type, :award_year_id], 
              name: 'index_form_answers_on_state_award_year' # For combined filtering

    # For comments table - improve flagged comments queries
    add_index :comments, [:commentable_id, :commentable_type, :section, :flagged],
              name: 'index_comments_on_commentable_and_flags'

    # For audit_certificates table - improve filtering for missing certificates
    add_index :audit_certificates, [:form_answer_id, :reviewed_at],
              name: 'index_audit_certificates_on_form_answer_and_review'
  end
end
