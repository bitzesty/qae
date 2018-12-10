class AddSicCodeToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :sic_code, :string
  end
end
