class CreateFormAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :form_answers do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
