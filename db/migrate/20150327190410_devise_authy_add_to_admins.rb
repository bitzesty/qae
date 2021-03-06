class DeviseAuthyAddToAdmins < ActiveRecord::Migration[4.2]
  def self.up
    change_table :admins do |t|
      t.string    :authy_id
      t.datetime  :last_sign_in_with_authy
      t.boolean   :authy_enabled, default: false
    end

    add_index :admins, :authy_id
  end

  def self.down
    change_table :admins do |t|
      t.remove :authy_id, :last_sign_in_with_authy, :authy_enabled
    end
  end
end

