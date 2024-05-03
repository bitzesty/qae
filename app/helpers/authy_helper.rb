module AuthyHelper
  def token_value
    if Authy.api_uri == "http://sandbox-api.authy.com/"
      "0000000"
    else
      ""
    end
  end
end
