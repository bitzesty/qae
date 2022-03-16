class Users::UnlocksController < Devise::UnlocksController
  include Users::ReasonablyParanoidable
end
