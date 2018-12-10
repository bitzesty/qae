class AddApplicantSubmittedToPressSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :applicant_submitted, :boolean, default: false
  end
end
