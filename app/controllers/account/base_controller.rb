class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_if_admin_in_read_only_mode!

  before_action :require_to_be_account_admin!, only: %i[
    new create update destroy
  ]
end
