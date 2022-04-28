class ChangeHasRoyalConnectionsDefaultValue < ActiveRecord::Migration[6.1]
  def up
    change_column :palace_attendees, :has_royal_family_connections, :boolean, default: nil
  end

  def down
    change_column :palace_attendees, :has_royal_family_connections, :boolean, default: false
  end
end
