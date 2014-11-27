class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :form_response, index: true
      t.references :question, index: true
      t.references :question_option, index: true
      t.string :input
      t.text :area
      t.date :date_value
      t.string :file

      t.timestamps
    end
  end
end
