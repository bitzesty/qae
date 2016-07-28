class RemoveSicCodeFromFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :sic_code, :string
  end
end
