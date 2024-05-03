# Run:
# AwardedTradeApplicationsCsv.run

class AwardedTradeApplicationsCsv
  CSV_HEADERS = [
    "Application number",
    "B4 Describe the geographical spread of your overseas markets.",
    "B4 What percentage of total overseas sales was made to each of your top 5 overseas markets (ie. individual countries) during the final year of your entry?",
  ]

  class << self
    def run
      ::CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv_out|
        csv_out << CSV_HEADERS

        AwardYear.first
                 .form_answers
                 .for_award_type(:trade)
                 .where(state: "awarded").each do |item|
          csv_out << [
            item.urn,
            item.document["markets_geo_spread"],
            item.document["top_overseas_sales"],
          ]
        end
      end
    end
  end
end
