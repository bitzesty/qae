class Admin::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  private

  def namespace
    ADMIN_NAMESPACE
  end
end
