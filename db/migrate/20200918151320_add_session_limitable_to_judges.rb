class AddSessionLimitableToJudges < ActiveRecord::Migration[5.2]
  def change
    add_column :judges, :unique_session_id, :string
  end
end
