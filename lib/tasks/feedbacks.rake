namespace :feedbacks do
  desc "Add locked_at to all submitted feedbacks"
  task populate_locked_at: :environment do
    Feedback.submitted.where(locked_at: nil).update_all(locked_at: Time.zone.now)
  end

  task populate_sustainable_development_feedback: :environment do
    FormAnswer.not_shortlisted.where(award_type: "development").each do |form_answer|
      feedback = form_answer.feedback || form_answer.build_feedback
      primary_assignment = form_answer.assessor_assignments.primary
      feedback.authorable ||= primary_assignment.assessor
      feedback.document ||= {}

      AppraisalForm.const_get("DEVELOPMENT_#{feedback.award_year.year}").each do |attr, val|
        next if val[:type] != :strengths

        feedback.document["#{attr}_rate"] = primary_assignment.document["#{attr}_rate"]
      end

      feedback.save!
    end
  end
end
