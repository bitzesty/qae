# here should be the logic responsible for submitting the form BY USER
# and all side effect actions

class FormAnswerUserSubmissionService
  attr_reader :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def perform
    Notifiers::Submission::SuccessNotifier.new(form_answer).run
  end
end
