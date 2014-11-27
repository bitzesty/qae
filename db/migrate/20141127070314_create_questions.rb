class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :form_step, index: true
      t.references :question, index: true
      t.string :title
      t.text :description
      t.string :element_type
      t.integer :placement
      t.text :note_above
      t.text :note_below
      t.text :hint_above
      t.text :hint_below
      t.boolean :visible
      t.boolean :is_subquestion
      t.boolean :is_optional
      t.string :css_class
      t.integer :css_size
      t.boolean :chars_limited
      t.string :view_template_path

      t.timestamps
    end
  end
end
