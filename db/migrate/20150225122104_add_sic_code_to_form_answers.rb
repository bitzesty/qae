class AddSicCodeToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :sic_code, :string
  end
end
