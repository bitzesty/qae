class CreateFormResponses < ActiveRecord::Migration
  def change
    create_table :form_responses do |t|
      t.references :form, index: true
      t.references :user, index: true
      t.string :devise_type
      t.string :state

      t.timestamps
    end
  end
end
