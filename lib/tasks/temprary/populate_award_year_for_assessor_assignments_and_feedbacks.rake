namespace :db do
  desc "Populate Award Year for AssessorAssignments and Feedbacks"
  task populate_award_year_for_assessor_assignments_and_feedbacks: :environment do
    AssessorAssignment.all.map { |a| a.update_column(:award_year_id, a.form_answer.award_year_id) }
    Feedback.all.map { |f| f.update_column(:award_year_id, f.form_answer.award_year_id) }
  end
end
