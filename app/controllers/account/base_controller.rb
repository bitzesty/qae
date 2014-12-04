class Account::BaseController < ApplicationController
  before_action :authenticate_account_admin!

  private

  def authenticate_account_admin!
    head :forbidden unless current_user.role.account_admin?
  end
end
