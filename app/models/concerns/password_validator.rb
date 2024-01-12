module PasswordValidator
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_password_validation
  end

  def password_required?
    return false if skip_password_validation
    super
  end
end
