module MailgunHelper
  class << self
    def email_invalid?(email)
      !valid?(email) if mailgun_public_key
    end

    private

    def query_ops(email)
      {
        params: {
          address: email,
        },
      }
    end

    def mailgun_public_key
      (Rails.env.test? ? "mailgun_public_key" : ENV["MAILGUN_PUBLIC_KEY"]) || raise("You need to supply your mailgun public api key")
    end

    def url(email)
      "https://api:#{mailgun_public_key}@api.mailgun.net/v2/address/validate?#{query_string(email)}"
    end

    def query_string(email)
      {
        address: email,
      }.to_query
    end

    def valid?(email)
      return true if Rails.env.test?
      body = Curl::Easy.perform(url(email)).body

      if (response = JSON.parse(body))
        return false if response.is_a?(Hash) && response["is_valid"].to_s == "false"
        response.size > 0
      end
    rescue
      false
    end
  end
end
