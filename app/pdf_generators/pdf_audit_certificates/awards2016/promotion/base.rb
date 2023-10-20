module PdfAuditCertificates::Awards2016::Promotion
  class Base < PdfAuditCertificates::Base

    # HERE YOU CAN OVERRIDE STANDART METHODS
    def render_content
      # No template for now
    end

    def header_full_award_type
      "Enterprise Promotion Award"
    end

    def award_type_short
      "Enterprise Promotion"
    end
  end
end
