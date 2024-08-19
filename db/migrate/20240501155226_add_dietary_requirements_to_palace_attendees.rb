class AddDietaryRequirementsToPalaceAttendees < ActiveRecord::Migration[7.0]
  def change
    add_column :palace_attendees, :dietary_requirements, :string
    add_column :palace_attendees, :disabled_access, :boolean
  end
end
