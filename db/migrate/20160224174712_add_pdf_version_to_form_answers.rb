class AddPdfVersionToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :pdf_version, :string
  end
end
