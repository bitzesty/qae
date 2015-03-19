class CreatePalaceAttendees < ActiveRecord::Migration
  def change
    create_table :palace_attendees do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :job_name
      t.string :post_nominals
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :address_4
      t.string :postcode
      t.string :phone_number
      t.string :product_description
      t.text :additional_info
      t.references :palace_invite, index: true

      t.timestamps null: false
    end
    add_foreign_key :palace_attendees, :palace_invites
  end
end
