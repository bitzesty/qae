class CreateSupportLetters < ActiveRecord::Migration
  def change
    create_table :support_letters do |t|
      t.references :supporter, index: true
      t.text :body

      t.timestamps
    end
  end
end
