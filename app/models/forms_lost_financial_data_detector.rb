# This class is used for detection of forms which was updated in specific date
# but after update financial data were lost.

# [1925, 2569, 998, 2582, 551, 2580, 2570, 2584, 2395, 2583, 1993, 2595, 2270, 2304, 750, 2596, 2572, 1572, 251, 2539, 2589, 26, 443, 2558, 2531, 2511, 2559, 564, 2555, 2532, 2561, 2601, 2602, 1333, 2600, 2593, 2594, 2548, 2535, 2536, 1705, 429, 1768, 1391, 2574, 2341, 677, 1406, 2547, 2560, 2348, 2162, 2240, 2302, 2314, 1945, 1714, 2206, 2543, 2494, 2553, 2578, 1117, 2352, 1584, 2549, 1371, 2250, 2211, 1161, 292, 1118, 2344, 1474, 1795, 2196, 2214, 2563]

class FormsLostFinancialDataDetector
  QUESTIONS = %w[
    employees_
    total_turnover_
    exports_
    uk_sales_
    net_profit_
    total_net_assets_
    units_sold_
    sales_
    sales_exports_
    sales_royalties_
    avg_unit_cost_self_
    overseas_sales_
    avg_unit_price_
  ]

  RANGE_OPTIONS = %w[day month year]
  THRESHOLD_OPTIONS = [2, 3, 5, 6]

  attr_accessor :forms, :date_of_update

  def initialize
    self.date_of_update = Date.new(2015, 9, 29)
    self.forms = fetch_forms
  end

  def restore; end

  def possible_question_keys
    QUESTIONS.map do |q|
      THRESHOLD_OPTIONS.map do |i|
        (1..i).to_a.map do |y|
          "#{q}#{y}of#{i}"
        end
      end
    end.flatten.uniq +
      financial_dates
  end

  def financial_dates
    RANGE_OPTIONS.map do |i|
      THRESHOLD_OPTIONS.map do |z|
        (1..z).to_a.map do |y|
          "financial_year_changed_dates_#{y}of#{z}#{i}"
        end
      end
    end.flatten.uniq
  end

  def set_form(f, doc)
    possible_question_keys.each do |k|
      Rails.logger.debug "[#{f.id}] #{k}: #{doc[k]}"
      if doc[k].present?
        Rails.logger.debug "[#{f.id}] #{k}: #{doc[k]} --------------- ADDED"
        f.document[k] = doc[k]
      end
    end

    f
  end

  def fetch_forms
    target_forms = FormAnswer.where(award_type: ["innovation", "development", "trade"])
                              .where("date(form_answers.updated_at) = ?", date_of_update)
                              .where("(document #>> '{employees_1of2}') IS NULL AND
                                     (document #>> '{employees_1of3}') IS NULL AND
                                     (document #>> '{employees_1of5}') IS NULL AND
                                     (document #>> '{employees_1of6}') IS NULL AND
                                     (document #>> '{total_turnover_1of2}') IS NULL AND
                                     (document #>> '{total_turnover_1of3}') IS NULL AND
                                     (document #>> '{total_turnover_1of5}') IS NULL AND
                                     (document #>> '{total_turnover_1of6}') IS NULL")

    target_forms.select do |f|
      possible_question_keys.any? do |k|
        f.document[k.to_s].blank?
      end
    end
  end

  def get_target_requests_from_logfile
    content = File.read(Rails.root.join("logfile.log"))
    entries = content.scan(/^(.*)Parameters: (.*)$/).select do |entry|
      entry[1].include?("current_step_id")
    end

    entries.map do |entry|
      hash_of_params = JSON.parse(entry[1].gsub!("=>", ":"))

      id = hash_of_params["id"]
      form = hash_of_params["form"]
      date = fetch_date(entry[0])

      [
        id,
        form,
        date,
      ]
    end.select do |item|
      # ids.include?(item[0].to_s) &&
      possible_question_keys.any? do |k|
        item[1][k.to_s].present?
      end
    end.sort do |a, b|
      b[2] <=> a[2]
    end
  end

  def fetch_date(str)
    str.split("[").last.split(".").first.to_datetime
  end
end
