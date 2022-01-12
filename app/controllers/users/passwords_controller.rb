class Users::PasswordsController < Devise::PasswordsController
  include Users::ReasonablyParanoidable
end
