class SeparateQaepUrnSequence < ActiveRecord::Migration[4.2]
  def up
    execute "CREATE SEQUENCE urn_seq_promotion;"
  end

  def down
    execute "DROP SEQUENCE urn_seq_promotion;"
  end
end
