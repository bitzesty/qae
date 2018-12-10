class AddSomeFieldsToSupportLetters < ActiveRecord::Migration[4.2]
  def change
    add_reference :support_letters, :user, index: true
    add_foreign_key :support_letters, :users

    add_reference :support_letters, :form_answer, index: true
    add_foreign_key :support_letters, :form_answers

    add_column :support_letters, :first_name, :string
    add_column :support_letters, :last_name, :string
    add_column :support_letters, :organization_name, :string
    add_column :support_letters, :phone, :string
    add_column :support_letters, :relationship_to_nominee, :text
    add_column :support_letters, :address_first, :string
    add_column :support_letters, :address_second, :string
    add_column :support_letters, :city, :string
    add_column :support_letters, :country, :string
    add_column :support_letters, :postcode, :string
  end
end
