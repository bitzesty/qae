class Admin::DeviseAuthyController < Devise::DeviseAuthyController
  layout "twofactor"

  def after_authy_enabled_path_for(_resource)
    admin_dashboard_index_path
  end
end
