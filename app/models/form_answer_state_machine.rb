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

  def automatic_states
    [:assessment_in_progress, :not_submitted]
  end

  def collection(subject)
    if subject.is_a?(Admin)
      STATES
    else
      (permitted_states_with_deadline_constraint - automatic_states) + Array(object.state.to_sym)
    end
  end

  def perform_transition(state, subject = nil)
    state = state.to_sym if STATES.map(&:to_s).include?(state)
    meta = {
      transitable_id: subject.id,
      transitable_type: subject.class.to_s
    } if subject.present?
    meta ||= {}
    if permitted_states_with_deadline_constraint.include?(state) || subject.is_a?(Admin)
      # Admin can change always and everything
      transition_to state, meta
    end
  end

  def submit(subject)
    perform_transition(:submitted, subject)
    # TODO: tech debt - we store the submitted state in 2 places
    # in state machine and in `form_answers.submitted`
    object.update(submitted: true)
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
      [
        :application_in_progress,
        :submitted,
        :withdrawn,
        :not_eligible
      ]
    else
      all_states = [
        :assessment_in_progress,
        :not_submitted,
        :recommended,
        :reserved,
        :not_recommended,
        :awarded,
        :not_awarded
      ]
      case object.state.to_sym
      when :withdrawn
        []
      when :not_eligible
        []
      when :application_in_progress
        [:not_submitted]
      when :submitted
        [:assessment_in_progress]
      when :not_submitted
        [:not_eligible]
      else
        all_states
      end
    end
  end
end
