class Admin::SettingsController < Admin::BaseController
  def index
    authorize :settings, :index?
  end
end
