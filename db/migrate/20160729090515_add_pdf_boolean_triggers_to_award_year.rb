class AddPdfBooleanTriggersToAwardYear < ActiveRecord::Migration
  def change
    add_column :award_years, :form_data_hard_copies_generated, :boolean
    add_column :award_years, :case_summary_hard_copies_generated, :boolean
    add_column :award_years, :feedback_hard_copies_generated, :boolean
  end
end
