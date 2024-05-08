class CheckAccountOnBouncesEmail

  DEBOUNCE_API_RESPONSE_CODES = {
    "1" => "Syntax. Not an email.",                       
    "2" => "Spam Trap. Spam-trap by ESPs.",                    
    "3" => "Disposable. A temporary, disposable address.",         
    "4" => "Accept-All. A domain-wide setting.",                 
    "5" => "Delivarable. Verified as real address.",                
    "6" => "Invalid. Verified as not valid.",             
    "7" => "Unknown. The server cannot be reached.",           
    "8" => "Role. Role accounts such as info, support, etc."
  }

  VALID_DEBOUNCE_API_CODES = [ 4, 5, 7, 8 ]

  attr_accessor :user,
                :email,
                :code

  def initialize(user)
    @user = user
    @email = user.email
  end

  def run!
    if debounce_api_says_it_is_valid?(email)
      user.update_column(:marked_at_bounces_email, nil)
      user.update_column(:debounce_api_response_code, nil)
    else
      user.update_column(:marked_at_bounces_email, true)
      user.update_column(:debounce_api_response_code, code)
    end

    user.update_column(:debounce_api_latest_check_at, Time.zone.now)
  end

  class << self
    def bounces_email?(email)
      User.bounced_emails
          .find_by(email: email)
          .present?
    end

    def bounce_reason(code)
      DEBOUNCE_API_RESPONSE_CODES[code]
    end
  end

  private

    def debounce_api_says_it_is_valid?(email)
      begin
        res = RestClient.get(
          "https://api.debounce.io/v1/?api=#{ENV['DEBOUNCE_API_KEY']}&email=#{email}", 
          {accept: :json}
        )
        @code = JSON.parse(res.body)["debounce"]["code"]

        VALID_DEBOUNCE_API_CODES.include?(code.to_i)
      rescue RestClient::Exceptions::ReadTimeout => e
        #
        # RARE CASE:
        #
        # Mark email as valid in case of getting Timeout error
        # as Debounce API sometimes returns Timeout error
        # for valid emails.
        #

        true
      end
    end
end