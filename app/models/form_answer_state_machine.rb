class FormAnswerStateMachine
  include Statesman::Machine

  STATES = [
    :application_in_progress,
    :submitted,
    :withdrawn,
    :not_eligible,
    :not_submitted,
    :assessment_in_progress,
    :recommended,
    :reserved,
    :not_recommended,
    :awarded,
    :not_awarded
  ]

  state :application_in_progress, initial: true
  state :submitted
  state :withdrawn
  state :not_eligible
  state :not_eligibile
  state :not_submitted
  state :assessment_in_progress
  state :recommended
  state :reserved
  state :not_recommended
  state :awarded
  state :not_awarded

  STATES.each do |state1|
    STATES.each do |state2|
      transition from: state1, to: state2
    end
  end

  def perform_transition(state, subject)
    meta = {
      transitable_id: subject.id,
      transitable_type: subject.class.to_s
    } if subject.present?
    meta ||= {}

    transition_to state, meta
  end

  def submit(subject)
    perform_transition(:submitted, subject)
  end

  def withdraw(subject)
    perform_transition(:withdrawn, subject)
  end

  def assign_lead_verdict(verdict, subject)
    new_state = {
      "negative" => :not_recommended,
      "average" => :reserved,
      "positive" => :recommended
    }[verdict]

    perform_transition(new_state, subject)
  end

  # store the state directly in model attribute
  after_transition do |model, transition|
    model.state = transition.to_state
    model.save
  end
end
