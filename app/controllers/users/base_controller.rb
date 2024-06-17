class Users::BaseController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
