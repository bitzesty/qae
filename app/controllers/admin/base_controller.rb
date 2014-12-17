class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!
end
