class AddNomineeTitleToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :nominee_title, :string
  end
end
