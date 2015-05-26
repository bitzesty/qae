class MigrateFormAnswersDocumentToJson < ActiveRecord::Migration
  def up
    rename_column :form_answers, :document, :hstore_document
    add_column :form_answers, :document, :json

    unless Rails.env.test?
      FormAnswer.reset_column_information

      updated_ids = []
      nil_ids = []

      FormAnswer.all.each do |form_answer|
        log_this("form_answer #{form_answer.id} - started")

        hstore_doc = form_answer.hstore_document

        if hstore_doc.present?
          document = FormAnswer::DocumentParser.parse_json_document(hstore_doc)
          form_answer.update_column(:document, document)

          updated_ids << form_answer.id

          log_this("form_answer #{form_answer.id} - updated")
        else
          log_this("form_answer #{form_answer.id} - not updated, because has nil document")

          nil_ids << form_answer.id
        end
      end

      log_this("[MigrateFormAnswersDocumentToJson] updated_ids: #{updated_ids.join(', ')}")
      log_this("[MigrateFormAnswersDocumentToJson] nil_ids: #{nil_ids.join(', ')}")
    end
  end

  def down
    remove_column :form_answers, :document
    rename_column :form_answers, :hstore_document, :document
  end

  private

  def log_this(message)
    m = "[MigrateFormAnswersDocumentToJson] #{message}"
    Rails.logger.info m
    puts m
  end
end
