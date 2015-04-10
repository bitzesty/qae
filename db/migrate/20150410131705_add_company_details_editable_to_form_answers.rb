class AddCompanyDetailsEditableToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :company_details_editable_id, :integer
    add_column :form_answers, :company_details_editable_type, :string
  end
end
