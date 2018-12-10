class AddSequenceFor2015AwardYear < ActiveRecord::Migration[4.2]
  def up
    execute "CREATE SEQUENCE urn_seq_promotion_2015;"
    execute "CREATE SEQUENCE urn_seq_2015;"
  end

  def down
    execute "DROP SEQUENCE urn_seq_promotion_2015;"
    execute "DROP SEQUENCE urn_seq_2015;"
  end
end
