class RemoveProductDescriptionFromPalaceAttendees < ActiveRecord::Migration
  def change
    remove_column :palace_attendees, :product_description
  end
end
