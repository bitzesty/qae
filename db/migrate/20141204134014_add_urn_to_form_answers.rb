class AddUrnToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :urn, :string
  end
end
