class AddFormAnswerMetadataTriggerFunction < ActiveRecord::Migration[7.0]
  def up
    add_column :form_answers, :metadata, :jsonb, default: {}, null: false
    add_index :form_answers, :metadata, using: :gin

    execute <<-SQL.squish
      DROP TRIGGER IF EXISTS form_answer_metadata_update ON form_answers;
      DROP FUNCTION IF EXISTS form_answer_metadata_trigger();
    SQL

    execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION form_answer_metadata_trigger() RETURNS trigger AS $$
      begin
        IF (TG_OP = 'INSERT') THEN
          NEW.metadata :=
          (
            SELECT
              (
                (CASE WHEN NEW.metadata IS NULL THEN json_build_object()::jsonb ELSE NEW.metadata END) ||
                json_build_object(
                  'registration_number', 
                  (
                    CASE WHEN (NEW.document::jsonb -> 'registration_number') IS NOT NULL THEN NEW.document::jsonb ->> 'registration_number'
                    ELSE '' END
                  ),
                  'product_estimated_figures', 
                  (
                    CASE WHEN (NEW.document::jsonb -> 'product_estimated_figures') IS NOT NULL THEN NEW.document::jsonb ->> 'product_estimated_figures'
                    ELSE NULL END
                  )
                )::jsonb
              )
            );
        END IF;

        IF (TG_OP = 'UPDATE') THEN
          NEW.metadata :=
          (
            SELECT
              (
                (CASE WHEN NEW.metadata IS NULL THEN json_build_object()::jsonb ELSE NEW.metadata END) ||
                json_build_object(
                  'registration_number', 
                  (
                    CASE WHEN (NEW.document::jsonb -> 'registration_number') IS NOT NULL THEN NEW.document::jsonb ->> 'registration_number'
                    ELSE NULL END
                  ),
                  'product_estimated_figures', 
                  (
                    CASE WHEN (NEW.document::jsonb -> 'product_estimated_figures') IS NOT NULL THEN NEW.document::jsonb ->> 'product_estimated_figures'
                    ELSE NULL END
                  )
                )::jsonb
              )
              FROM form_answers WHERE form_answers.id = NEW.id
            );
        END IF;

        return NEW;
      end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER dog_metadata_update BEFORE INSERT OR UPDATE
      ON form_answers FOR EACH ROW EXECUTE PROCEDURE form_answer_metadata_trigger();
    SQL

    execute <<-SQL.squish
      UPDATE form_answers SET updated_at = now()
    SQL
  end

  def down
    execute <<-SQL.squish
      DROP FUNCTION IF EXISTS form_answer_metadata_trigger() CASCADE;
      DROP TRIGGER IF EXISTS form_answer_metadata_update ON form_answers CASCADE;
    SQL

    remove_column :form_answers, :metadata, :jsonb
  end
end