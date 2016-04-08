module DashboardHelper
  def show_applications?
    show_winners = (
      Settings.winners_stage? &&
      @user_award_forms_submitted.select{ |app| app.awarded? }.any?
    )

    !Settings.after_current_submission_deadline? ||
    show_winners ||
    Settings.unsuccessful_stage? ||
    past_applications.present?
  end
end
