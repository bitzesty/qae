class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_to_be_account_admin!
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  private

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to root_path,
                  notice: "Access denied!"
    end
  end
end
