class FeedbackCreationService
  attr_reader :form_answer, :user

  def initialize(form_answer, user)
    @form_answer = form_answer
    @user = user
  end

  def perform
    return unless form_answer.development?

    populate_feedback!
  end

  private

  def populate_feedback!
    return if form_answer.feedback.present?

    feedback = form_answer.build_feedback
    feedback.authorable = user
    feedback.document = {}
    primary_assignment = form_answer.assessor_assignments.primary
    year = form_answer.award_year.year

    AppraisalForm.const_get("DEVELOPMENT_#{year}").each do |attr, val|
      next if val[:type] != :strengths

      feedback.document["#{attr}_rate"] = primary_assignment.document["#{attr}_rate"]
    end

    feedback.save!
  end
end
