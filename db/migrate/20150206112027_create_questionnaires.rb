class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.integer :payment_usability_rating
      t.integer :security_rating
      t.integer :overall_payment_rating
      t.text :improvement_proposal
      t.boolean :completed, default: false
      t.references :form_answer, index: true

      t.timestamps
    end
  end
end
