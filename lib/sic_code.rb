require "csv"

class SicCode < ActiveYaml::Base
  REGEX = /\A\d{4}(\/\d{1})?\z/ # based on the sic codes spreadsheet

  set_root_path "#{Rails.root}/db/fixtures"
  set_filename "sic_codes"

  def self.load_csv(csv_filename = "#{Rails.root}/sic_codes.csv")
    csv = CSV.parse File.open(csv_filename).read

    headers = {
      0 => "code",
      1 => "description",
      2 => "year1",
      3 => "year2",
      4 => "year3",
      5 => "year4",
      6 => "year5",
      7 => "year6"
    }

    res = csv[1..-1].map do |row|
      out = {}
      headers.each do |index, attr_name|
        out[attr_name] = row[index]
      end
      out
    end

    file = File.open("#{Rails.root}/sic_codes.yml", "w+")
    file.write(res.to_yaml)
    file.close
  end

  NOTES = {
    "999" => "SIC codes for Service activities (for which there are no sector averages)",
    "99*" => "Those SIC codes with an export sales ratio of 100% or more have",
    "50*" => "SIC codes for General Merchant activities (for which there are no sector averages)",
    "1*" => "Those SIC codes for which the sector is not covered in PRODCOM database,
    UK exports published as zero, no principal products, UK sales and/or exports not
    available or suppressed implying ratios not defined or no principal products for
    some years and ratios smaller than 0.5%"
  }

  def by_year(year)
    public_send("year#{year}")
  end

  def name
    "#{code} - #{description}"
  end

  def self.collection
    SicCode.all.sort_by(&:code).map { |sic| [sic.name, sic.code] }
  end
end
