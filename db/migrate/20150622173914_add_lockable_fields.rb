class AddLockableFields < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end

    change_table :assessors do |t|
      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end

    change_table :admins do |t|
      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end


    add_index :users, :unlock_token,         unique: true
    add_index :assessors, :unlock_token,     unique: true
    add_index :admins, :unlock_token,        unique: true
  end
end
