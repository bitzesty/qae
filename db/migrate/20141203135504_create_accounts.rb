class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|

      t.timestamps
    end
  end
end
