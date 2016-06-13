module QAE
  class << self
    def env
      ENV['COOKIE_DOMAIN']
    end

    def production?
      env == 'www.queens-awards-enterprise.service.gov.uk'
    end
  end
end
