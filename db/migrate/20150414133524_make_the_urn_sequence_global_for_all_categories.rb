class MakeTheUrnSequenceGlobalForAllCategories < ActiveRecord::Migration
  def up
    execute 'DROP SEQUENCE "urn_seq_trade";'
    execute 'DROP SEQUENCE "urn_seq_innovation";'
    execute 'DROP SEQUENCE "urn_seq_development";'
    execute 'DROP SEQUENCE "urn_seq_promotion";'
    execute "CREATE SEQUENCE urn_seq;"
  end

  def down
    execute "DROP SEQUENCE urn_seq;"
    execute 'CREATE SEQUENCE "urn_seq_trade";'
    execute 'CREATE SEQUENCE "urn_seq_innovation";'
    execute 'CREATE SEQUENCE "urn_seq_development";'
    execute 'CREATE SEQUENCE "urn_seq_promotion";'
  end
end
