class AddCompanyOrNomineeNameToTheFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :company_or_nominee_name, :string

    FormAnswer.all.each do |f|
      f.company_or_nominee_name = f.company_or_nominee_from_document
      f.save
    end
  end
end
