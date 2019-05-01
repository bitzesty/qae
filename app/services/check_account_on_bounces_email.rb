class CheckAccountOnBouncesEmail

  #
  # Debounce.io API responce codes:
  #
  # TEXT CODE   NUMERIC CODE  DESCRIPTION                               SAFE TO SEND?
  #
  # Syntax      1             Not an email.                             No
  # Spam Trap   2             Spam-trap by ESPs.                        No
  # Disposable  3             A temporary, disposable address.          No
  # Accept-All  4             A domain-wide setting.                    Maybe Not recommended unless on private server
  # Delivarable 5             Verified as real address.                 Yes
  # Invalid     6             Verified as not valid.                    No
  # Unknown     7             The server cannot be reached.             No
  # Role        8             Role accounts such as info, support, etc. Maybe Not recommended

  VALID_DEBOUNCE_API_CODES = [ 4, 5, 8 ]

  attr_accessor :user,
                :email

  def initialize(user)
    @user = user
    @email = user.email
  end

  def run!
    unless debounce_api_says_it_is_valid?(email)
      user.update_column(:marked_as_bounces_email_at, Time.zone.now)
    end
  end

  private

    def debounce_api_says_it_is_valid?(email)
      res = RestClient.get(
        "https://api.debounce.io/v1/?api=#{ENV['DEBOUNCE_API_KEY']}&email=#{email}", 
        {accept: :json}
      )
      code = JSON.parse(res.body)['debounce']['code']

      VALID_DEBOUNCE_API_CODES.include?(code.to_i)
    end
end