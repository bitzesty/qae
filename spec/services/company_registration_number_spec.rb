# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompanyRegistrationNumber do
  describe ".extract_from" do
    it "extracts company registration number from simple string" do
      content = "06883289"

      expect(
        described_class.extract_from(content),
      ).to match_array(["06883289"])
    end

    it "extracts company registration number from simple string when it is shortened" do
      content = "6883289"

      expect(
        described_class.extract_from(content),
      ).to match_array(["6883289"])
    end

    it "extracts company registration number from HTML block" do
      content = %Q{<blockquote>Registered Company Number -&nbsp;.06883289</blockquote>\r\n\r\n<p>&nbsp;</p>\r\n}
      alternative_content = %Q{<p>My company number is :06883289.</p>\r\n}

      expect(
        described_class.extract_from(content),
      ).to match_array(["06883289"])

      expect(
        described_class.extract_from(alternative_content),
      ).to match_array(["06883289"])
    end

    it "extracts multiple company registration numbers from HTML block" do
      content = %Q{<p>My company numbers are 06883289 and 02429054 as well as 05637000</p>\r\n}

      expect(
        described_class.extract_from(content),
      ).to match_array(["06883289", "02429054", "05637000"])
    end
  end
end

