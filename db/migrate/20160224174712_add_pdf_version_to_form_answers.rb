class AddPdfVersionToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :pdf_version, :string
  end
end
