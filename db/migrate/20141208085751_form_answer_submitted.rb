class FormAnswerSubmitted < ActiveRecord::Migration
  def up
    add_column :form_answers, :submitted, :boolean
    execute 'CREATE SEQUENCE "urn_seq_trade";'
    execute 'CREATE SEQUENCE "urn_seq_innovation";'
    execute 'CREATE SEQUENCE "urn_seq_development";'
    execute 'CREATE SEQUENCE "urn_seq_promotion";'
  end

  def down
    remove_column :form_answers, :submitted
    execute 'DROP SEQUENCE "urn_seq_trade";'
    execute 'DROP SEQUENCE "urn_seq_innovation";'
    execute 'DROP SEQUENCE "urn_seq_development";'
    execute 'DROP SEQUENCE "urn_seq_promotion";'
  end
end
