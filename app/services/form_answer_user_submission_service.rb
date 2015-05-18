# here should be the logic responsible for submitting the form BY USER
# and all side effect actions

class FormAnswerUserSubmissionService
  attr_reader :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def perform
    assign_previous_wins
    Notifiers::Submission::SuccessNotifier.new(form_answer).run
  end

  private

  def assign_previous_wins
    return unless form_answer.previous_wins.blank?

    award_holder_details = form_answer.document["queen_award_holder_details"]
    if award_holder_details.present?
      json = JSON.parse(award_holder_details)
      json.each do |win|
        win = JSON.parse(win)
        form_answer.previous_wins.create(category: win["category"], year: win["year"] )
      end
    end
  end
end
