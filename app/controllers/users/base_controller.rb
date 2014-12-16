class Users::BaseController < ApplicationController
  before_action :authenticate_user!

  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]
end
