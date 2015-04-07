class AddCompanyDetailsUpdatedAtToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :company_details_updated_at, :datetime
  end
end
