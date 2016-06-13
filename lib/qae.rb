module QAE
  class << self
    def env
      ENV['COOKIE_DOMAIN']
    end

    def production?
      env == 'www.queens-awards-enterprise.service.gov.uk'
    end

    def hide_pdf_links?
      ENV['HIDE_PDF_LINKS'] == 'true'
    end
  end
end
