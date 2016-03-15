module SendgridHelper
  class << self
    def spam_reported?(email)
      handle_response(spam_reported_url(email)) if can_access_sendgrid?
    end

    def bounced?(email)
      handle_response(bounced_url(email)) if can_access_sendgrid?
    end

    def smtp_alive?(host, port)
      Net::SMTP.start(host, port) do |smtp|
        smtp.enable_starttls_auto
        smtp.ehlo(Socket.gethostname)
        smtp.finish
      end
      true
    rescue StandardError => e
      false
    end

    private

    def can_access_sendgrid?
      smtp_settings[:user_name] && smtp_settings[:password]
    end

    def query_string(email)
      {
        api_user: smtp_settings[:user_name],
        api_key: smtp_settings[:password],
        email: email,
      }.to_query
    end

    def smtp_settings
      {
        user_name: ENV.fetch('SENDGRID_USERNAME', 'test_smtp_username'),
        password:  ENV.fetch('SENDGRID_PASSWORD', 'test_smtp_password')
      }
    end

    def spam_reported_url(email)
      "https://sendgrid.com/api/spamreports.get.json?#{query_string(email)}"
    end

    def bounced_url(email)
      "https://sendgrid.com/api/bounces.get.json#{query_string(email)}"
    end

    def handle_response(url)
      body = Curl::Easy.perform(url).body_str
      if response = JSON.parse(body)
        return false if response.is_a?(Hash) && response[:error]
        response.size > 0
      end
    rescue Curl::Err::CurlError, JSON::ParserError => e
      false
    end
  end
end
