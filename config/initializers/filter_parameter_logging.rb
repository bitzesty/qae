# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[password password_confirmation current_password first_name last_name phone_number email address principal_address postcode]
