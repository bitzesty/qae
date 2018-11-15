class RemoveProductDescriptionFromPalaceAttendees < ActiveRecord::Migration[4.2]
  def change
    remove_column :palace_attendees, :product_description
  end
end
