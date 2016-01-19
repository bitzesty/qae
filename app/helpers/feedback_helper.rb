module FeedbackHelper
  def submit_feedback_title(feedback)
    prefix = policy(feedback).can_be_submitted? ? "Submit" : "Re-submit"
    "#{prefix} Feedback"
  end
end
