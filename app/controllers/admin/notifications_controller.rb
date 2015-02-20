class Admin::NotificationsController < Admin::BaseController
  def confirm_notify_shortlisted
    @confirmation = ActionConfirmationForm.new
  end

  def trigger_notify_shortlisted
    @confirmation = ActionConfirmationForm.new
    @confirmation.attributes = params[:confirmation]

    if @confirmation.valid? && @confirmation.notify!(Users::NotifyShortlistedMailer, User.shortlisted)
      flash.notice = 'Shortlisted users were successfully notified'
    else
      flash.alert = 'Action was not confirmed'
    end

    redirect_to admin_dashboard_index_path
  end

  def confirm_notify_non_shortlisted
    @confirmation = ActionConfirmationForm.new
  end

  def trigger_notify_non_shortlisted
    @confirmation = ActionConfirmationForm.new
    @confirmation.attributes = params[:confirmation]

    if @confirmation.valid? && @confirmation.notify!(Users::NotifyNonShortlistedMailer, User.non_shortlisted)
      flash.notice = 'Non-shortlisted users were successfully notified'
    else
      flash.alert = 'Action was not confirmed'
    end

    redirect_to admin_dashboard_index_path
  end
end
