class AddAggregatedHardCopyStatesToAwardYears < ActiveRecord::Migration[4.2]
  def change
    add_column :award_years, :aggregated_case_summary_hard_copy_state, :string
    add_column :award_years, :aggregated_feedback_hard_copy_state, :string
  end
end
