# http://docs.authy.com/
require 'authy'

Authy.api_key = ENV["AUTHY_API_KEY"] || "0cd08abec2e9b9641e40e9470a7fc336"
# TEST Verification TOKEN = "0000000"
Authy.api_uri = ENV["AUTHY_API_URL"] || "http://sandbox-api.authy.com/"
