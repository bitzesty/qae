class ChangeRelationshipToNomineeInSupporters < ActiveRecord::Migration[4.2]
  def up
    change_column :supporters, :relationship_to_nominee, :string
    change_column :support_letters, :relationship_to_nominee, :string
  end

  def down
    change_column :supporters, :relationship_to_nominee, :text
    change_column :support_letters, :relationship_to_nominee, :text
  end
end
