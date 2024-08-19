module FormAnswerStatesHelper
  def unsuccessful?
    not_recommended? || not_awarded?
  end

  def submitted_and_after_the_deadline?
    submitted? && Settings.after_current_submission_deadline?
  end

  (FormAnswerStateMachine::STATES - [:submitted]).each do |permitted_state|
    define_method(:"#{permitted_state}?") do
      state == permitted_state.to_s
    end
  end
end
