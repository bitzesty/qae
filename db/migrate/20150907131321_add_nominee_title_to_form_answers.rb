class AddNomineeTitleToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :nominee_title, :string
  end
end
