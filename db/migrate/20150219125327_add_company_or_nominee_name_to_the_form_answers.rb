class AddCompanyOrNomineeNameToTheFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :company_or_nominee_name, :string
  end
end
