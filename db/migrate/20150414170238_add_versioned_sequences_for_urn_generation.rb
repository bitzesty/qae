class AddVersionedSequencesForUrnGeneration < ActiveRecord::Migration[4.2]
  def up
    execute "DROP SEQUENCE urn_seq_promotion;"
    execute "DROP SEQUENCE urn_seq;"

    50.times do |i|
      year = 2016 + i
      execute "CREATE SEQUENCE urn_seq_promotion_#{year};"
      execute "CREATE SEQUENCE urn_seq_#{year};"
    end
  end

  def down
    execute "CREATE SEQUENCE urn_seq_promotion;"
    execute "CREATE SEQUENCE urn_seq;"

    50.times do |i|
      year = 2016 + i
      execute "DROP SEQUENCE urn_seq_promotion_#{year};"
      execute "DROP SEQUENCE urn_seq_#{year};"
    end
  end
end
