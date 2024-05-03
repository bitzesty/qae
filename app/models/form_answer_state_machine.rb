class FormAnswerStateMachine
  include Statesman::Machine

  STATES = %i[
    eligibility_in_progress
    application_in_progress
    submitted
    withdrawn
    not_eligible
    not_submitted
    assessment_in_progress
    disqualified
    recommended
    reserved
    not_recommended
    awarded
    not_awarded
  ]

  POSITIVE_STATES = %i[
    reserved
    recommended
    awarded
  ]

  POST_SUBMISSION_STATES = %i[
    submitted
    withdrawn
    assessment_in_progress
    disqualified
    recommended
    reserved
    not_recommended
    awarded
    not_awarded
  ]

  NOT_POSITIVE_STATES = %i[
    not_recommended
    not_awarded
  ]

  state :eligibility_in_progress, initial: true
  state :application_in_progress
  state :submitted
  state :withdrawn
  state :not_eligible
  state :not_submitted
  state :assessment_in_progress
  state :disqualified
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
    return unless Settings.after_current_submission_deadline?

    current_year = Settings.current.award_year

    current_year.form_answers.where(state: "submitted").find_each do |fa|
      fa.state_machine.perform_transition("assessment_in_progress")
    end

    current_year.form_answers.in_progress.find_each do |fa|
      fa.state_machine.perform_transition("not_submitted")
    end
  end

  def self.trigger_audit_deadlines
    return unless Settings.after_current_audit_certificates_deadline?

    current_year = Settings.current.award_year

    current_year.form_answers.require_vocf.where(state: "assessment_in_progress").find_each do |fa|
      fa.state_machine.perform_transition("disqualified") if !fa.audit_certificate || fa.audit_certificate.attachment.blank?
    end

    current_year.form_answers.vocf_free.provided_estimates.where(state: "assessment_in_progress").find_each do |fa|
      if !fa.shortlisted_documents_wrapper || !fa.shortlisted_documents_wrapper.submitted?
        fa.state_machine.perform_transition("disqualified")
      end
    end
  end

  def collection(_subject)
    permitted_states_with_deadline_constraint
  end

  def perform_transition(state, subject = nil, validate = true)
    state = state.to_sym if STATES.map(&:to_s).include?(state)
    meta = get_metadata(subject)

    return unless permitted_states_with_deadline_constraint.include?(state) || !validate
    return unless transition_to state, meta

    object.update(submitted_at: Time.current) if state == :submitted

    Notifiers::WithdrawNotifier.new(object).notify if state == :withdrawn

    return unless %i[not_awarded not_recommended].include?(state)

    FeedbackCreationService.new(object, subject).perform
  end

  def perform_simple_transition(state)
    perform_transition(state, nil, false) unless object.state == state
  end

  def submit(subject)
    # TODO: tech debt - we store the submitted state in 2 places
    # in state machine and in `form_answers.submitted`
    meta = get_metadata(subject)
    transition_to :submitted, meta
    object.update(submitted_at: Time.current)
  end

  def assign_lead_verdict(verdict, subject)
    new_state = {
      "negative" => :not_recommended,
      "average" => :reserved,
      "positive" => :recommended,
    }[verdict]

    perform_transition(new_state, subject)
  end

  def after_eligibility_step_progress
    if object.eligible? # already eligible
      perform_simple_transition :application_in_progress
    else
      perform_simple_transition :eligibility_in_progress
    end
  end

  def after_eligibility_step_failure
    perform_simple_transition :not_eligible
  end

  # store the state directly in model attribute
  after_transition do |model, transition|
    model.state = transition.to_state
    model.save
  end

  private

  def get_metadata(subject)
    if subject.present?
      meta = {
        transitable_id: subject.id,
        transitable_type: subject.class.to_s,
      }
    end
    meta ||= {}
    meta
  end

  def permitted_states_with_deadline_constraint
    if Settings.after_current_submission_deadline?
      all_states = %i[
        assessment_in_progress
        recommended
        reserved
        not_recommended
        disqualified
        awarded
        not_awarded
        withdrawn
      ]

      case object.state.to_sym
      when :not_eligible
        []
      when :application_in_progress, :eligibility_in_progress
        [:not_submitted]
      when :submitted
        [:assessment_in_progress]
      when :not_submitted
        []
      else
        all_states
      end
    else
      []
    end
  end
end
