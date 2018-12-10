class RemoveSicCodeFromFormAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :form_answers, :sic_code, :string
  end
end
