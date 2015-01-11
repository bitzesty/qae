class Account::BaseController < ApplicationController
  before_action :authenticate_account_admin!
  before_action :check_basic_eligibility, :check_award_eligibility
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  private

  def authenticate_account_admin!
    head :forbidden unless current_user.role.account_admin?
  end
end
