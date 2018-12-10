class AddAdvancedHardCopyGenerationStatesToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    rename_column :form_answers, :hard_copy_generated, :form_data_hard_copy_generated

    add_column :form_answers, :case_summary_hard_copy_generated, :boolean, default: false
    add_column :form_answers, :feedback_hard_copy_generated, :boolean, default: false
  end
end
