class CreateFormSteps < ActiveRecord::Migration
  def change
    create_table :form_steps do |t|
      t.references :form, index: true
      t.string :title
      t.text :description
      t.text :note
      t.integer :placement

      t.timestamps
    end
  end
end
