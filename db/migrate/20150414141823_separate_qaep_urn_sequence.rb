class SeparateQaepUrnSequence < ActiveRecord::Migration
  def up
    execute "CREATE SEQUENCE urn_seq_promotion;"
  end

  def down
    execute "DROP SEQUENCE urn_seq_promotion;"
  end
end
