class CreatePalaceInvites < ActiveRecord::Migration[4.2]
  def change
    create_table :palace_invites do |t|
      t.string :email
      t.references :form_answer, index: true
      t.string :token

      t.timestamps null: false
    end
    add_foreign_key :palace_invites, :form_answers
  end
end
