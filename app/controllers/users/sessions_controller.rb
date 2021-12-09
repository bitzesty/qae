class Users::SessionsController < Devise::SessionsController
  def create
    super
    flash.discard(:notice)
  end
end
