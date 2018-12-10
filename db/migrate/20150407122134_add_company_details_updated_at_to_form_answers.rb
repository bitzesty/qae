class AddCompanyDetailsUpdatedAtToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :company_details_updated_at, :datetime
  end
end
