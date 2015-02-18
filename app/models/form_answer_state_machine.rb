class FormAnswerStateMachine

  include Statesman::Machine

  # Prior to End of September Deadline (phase I)
  state :in_progress1, initial: true
  state :submitted1
  state :not_eligible1
  state :withdrawn1
  state :eligible1

  # After September Deadline (phase II)
  state :not_submitted2
  state :not_eligible2
  state :assessment_in_progress2
  state :withdrawn2

  # After Initial Assessment has been made (phase III)
  state :recommended3
  state :reserved3
  state :not_recommended3
  state :withdrawn3

  # After Judges Panel (phase IV)
  state :recommended4
  state :reserved4
  state :not_recommended4
  state :withdrawn4

  # After PM's Committee (phase V)
  state :recommended5
  state :reserved5
  state :not_recommended5
  state :withdrawn5

  # After Queen's Decision
  state :awarded6
  state :not_awarded6
  state :not_eligible6
  state :not_submitted6

  # let's enable all transitions for now
  STATES = [
    :in_progress1,
    :submitted1,
    :not_eligible1,
    :withdrawn1,
    :eligible1,
    :not_submitted2,
    :not_eligible2,
    :assessment_in_progress2,
    :withdrawn2,
    :recommended3,
    :reserved3,
    :not_recommended3,
    :withdrawn3,
    :recommended4,
    :reserved4,
    :not_recommended4,
    :withdrawn4,
    :recommended5,
    :reserved5,
    :not_recommended5,
    :withdrawn5,
    :awarded6,
    :not_awarded6,
    :not_eligible6,
    :not_submitted6
  ]

  STATES.each do |state1|
    STATES.each do |state2|
      transition from: state1, to: state2
    end
  end
end