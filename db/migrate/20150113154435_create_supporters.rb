class CreateSupporters < ActiveRecord::Migration
  def change
    create_table :supporters do |t|
      t.references :form_answer, index: true
      t.string :email
      t.string :access_key, index: true

      t.timestamps
    end
  end
end
