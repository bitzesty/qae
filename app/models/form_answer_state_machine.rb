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

  def self.trigger_deadlines
    time = DateTime.now
    ends = Deadline.with_states_to_trigger.includes(:settings)
    relevant_states = [
      "submitted",
      "application_in_progress"
    ]
    ends.each do |deadline|
      year = deadline.settings.year + 1 # TODO: seems to be right - clarify
      form_answers = FormAnswer.where(award_year: year).where(state: relevant_states)

      form_answers.each do |fa|
        if fa.state == "submitted"
          fa.state_machine.perform_transition("assessment_in_progress")
        end

        if fa.state == "application_in_progress"
          fa.state_machine.perform_transition("not_submitted")
        end
      end
    end
  end

  def permitted_states_with_current_state_constraint(state)
    case state
    when :not_submitted
      []
    else
      STATES
    end
  end

  def automatic_states
    [:assessment_in_progress, :not_submitted]
  end

  def collection
    (permitted_states_with_deadline_constraint - automatic_states) &
      permitted_states_with_current_state_constraint(object.state.to_sym)
  end

  def perform_transition(state, subject = nil)
    state = state.to_sym if STATES.map(&:to_s).include?(state)
    meta = {
      transitable_id: subject.id,
      transitable_type: subject.class.to_s
    } if subject.present?
    meta ||= {}
    transition_to state, meta if collection.include?(state)
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

  private

  def permitted_states_with_deadline_constraint
    year = object.award_year
    settings = Settings.for_year(year - 1)
    deadline = settings.deadlines.where(kind: "submission_end").first

    # time restrictions
    return [] if deadline.trigger_at.blank?

    if DateTime.now < deadline.trigger_at
      states = [
        :application_in_progress,
        :submitted,
        :withdrawn,
        :not_eligible
      ]
    end

    if DateTime.now > deadline.trigger_at
      states = [
        :assessment_in_progress,
        :not_submitted,
        :recomended,
        :reserved,
        :not_recommended,
        :awarded,
        :not_awarded,
        :withdrawn,
        :not_eligible
      ]
    end
    states
  end
end
