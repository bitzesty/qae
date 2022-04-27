class AddHasRoyalFamilyConnectionsToPalaceAttendees < ActiveRecord::Migration[6.1]
  def change
    add_column :palace_attendees, :has_royal_family_connections, :boolean,default: false
    add_column :palace_attendees, :royal_family_connection_details, :text
  end
end
