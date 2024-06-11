class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_if_admin_in_read_only_mode!

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :require_to_be_account_admin!, only: [
    :new, :create, :update, :destroy
  ]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
