class Admin::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  private

  def namespace
    "admins"
  end
end
