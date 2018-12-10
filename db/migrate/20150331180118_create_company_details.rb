class CreateCompanyDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :company_details do |t|
      t.string :address_building
      t.string :address_street
      t.string :address_city
      t.string :address_country
      t.string :address_postcode
      t.string :telephone
      t.string :region
      t.integer :form_answer_id, null: false

      t.timestamps
    end

    add_index :company_details, :form_answer_id, unique: true
  end
end
