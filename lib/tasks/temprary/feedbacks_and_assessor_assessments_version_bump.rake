namespace :db do
  desc "Feedbacks and AssessorAssignments version bump"
  task feedbacks_and_assessor_assessments_version_bump: :environment do
    AssessorAssignment.all.map { |f| f.touch_with_version }
    Feedback.all.map { |f| f.touch_with_version }
  end
end
