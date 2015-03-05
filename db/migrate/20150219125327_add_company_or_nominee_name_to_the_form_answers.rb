class AddCompanyOrNomineeNameToTheFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :company_or_nominee_name, :string
  end
end
