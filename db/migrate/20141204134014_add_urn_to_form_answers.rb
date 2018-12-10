class AddUrnToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :urn, :string
  end
end
