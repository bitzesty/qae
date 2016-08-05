class ChangeTriggerColumnsInAwardYears < ActiveRecord::Migration
  def change
    remove_column :award_years, :form_data_hard_copies_generated
    remove_column :award_years, :case_summary_hard_copies_generated
    remove_column :award_years, :feedback_hard_copies_generated

    add_column :award_years, :form_data_hard_copies_state, :string
    add_column :award_years, :case_summary_hard_copies_state, :string
    add_column :award_years, :feedback_hard_copies_state, :string
  end
end
