class FeedbackCreationService
  attr_reader :form_answer, :user

  def initialize(form_answer, user)
    @form_answer = form_answer
    @user = user
  end

  def perform
    if form_answer.development?
      populate_feedback!
    end
  end

  private

  def populate_feedback!
    return if form_answer.feedback

    feedback = form_answer.build_feedback
    feedback.authorable = user
    feedback.document = {}
    primary_assignment = form_answer.assessor_assignments.primary

    AppraisalForm::DEVELOPMENT.each do |attr, val|
      next if val[:type] != :strengths

      feedback.document["#{attr}_rate"] = primary_assignment.document["#{attr}_rate"]
    end

    feedback.save!
  end
end
