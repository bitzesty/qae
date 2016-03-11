class AddApplicantSubmittedToPressSummaries < ActiveRecord::Migration
  def change
    add_column :press_summaries, :applicant_submitted, :boolean, default: false
  end
end
