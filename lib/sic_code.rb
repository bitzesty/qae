require 'csv'

class SICCode < ActiveYaml::Base
  REGEX = /\A\d{4}(\/\d{1})?\z/ # based on the sic codes spreadsheet

  set_root_path Rails.root
  set_filename "sic_codes"

  def self.load_csv(csv_filename = "#{Rails.root}/sic_codes.csv")
    csv = CSV.parse File.open(csv_filename).read

    headers = {
      0 => 'code',
      1 => 'description',
      2 => 'year1',
      3 => 'year2',
      4 => 'year3',
      5 => 'year4',
      6 => 'year5',
      7 => 'year6'
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

  def by_year(year)
    public_send("year#{year}")
  end
end
