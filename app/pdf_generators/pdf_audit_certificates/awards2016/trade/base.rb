module PdfAuditCertificates::Awards2016::Trade
  class Base < AuditCertificatePdf
    # HERE YOU CAN OVERRIDE STANDART METHODS
    def render_options_list
      render_options(
        "Option 1 - In accordance with instructions received from our client, International Rescue UK Ltd, we have examined the above figures for the entry for The Queen's Awards for Enterprise: International Trade 2015. We confirm that, in our opinion, the entry correctly states the information required and that the applicable accounting standards have been complied with.",
        "Option 2 - In accordance with instructions received from our client, International Rescue UK Ltd, we have examined the above figures for the entry for The Queen's Awards for Enterprise: International Trade 2015. We confirm that, in our opinion, the entry, as revised by the included Schedule and explanation of the changes, correctly states the information required and that the applicable accounting standards have been complied with."
      )
    end
  end
end
