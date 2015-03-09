class Admin::SettingsController < Admin::BaseController
  before_action :load_settings, :load_email_notifications, only: [:show]

  def show
    authorize :settings, :show?
  end

  private

  def load_email_notifications
    @email_notifications = @settings.email_notifications.order(:trigger_at).to_a
  end
end
