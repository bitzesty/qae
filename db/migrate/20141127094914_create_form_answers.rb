class CreateFormAnswers < ActiveRecord::Migration
  def change
    create_table :form_answers do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
