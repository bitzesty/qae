# This class is used for detection of forms which was updated in specific date
# but after update financial data were lost.

class FormsLostFinancialDataDetector

  QUESTIONS = [
    "employees_",
    "total_turnover_",
    "exports_",
    "uk_sales_",
    "net_profit_",
    "total_net_assets_",
    "units_sold_",
    "sales_",
    "sales_exports_",
    "sales_royalties_",
    "avg_unit_cost_self_",
    "overseas_sales_",
    "avg_unit_price_",
    "total_imported_cost_",
    "overseas_yearly_percentage_"
  ]

  attr_accessor :forms, :date_of_update

  def initialize
    self.date_of_update = Date.new(2015,9,29)
    self.forms = fetch_forms
  end

  def possible_question_keys
    QUESTIONS.map do |q|
      [2, 3, 5, 6].map do |i|
        (1..i).to_a.map do |y|
          "#{q}#{y}_#{i}"
        end
      end
    end.flatten.uniq
  end

  def fetch_forms
    target_forms = FormAnswer.where(award_type: ["innovation", "development", "trade"]).
                              where("date(form_answers.updated_at) = ?", date_of_update).
                              where("(document #>> '{employees_1of2}') IS NULL AND
                                     (document #>> '{employees_1of3}') IS NULL AND
                                     (document #>> '{employees_1of5}') IS NULL AND
                                     (document #>> '{employees_1of6}') IS NULL AND
                                     (document #>> '{total_turnover_1of2}') IS NULL AND
                                     (document #>> '{total_turnover_1of3}') IS NULL AND
                                     (document #>> '{total_turnover_1of5}') IS NULL AND
                                     (document #>> '{total_turnover_1of6}') IS NULL")

    target_forms.select do |f|
      possible_question_keys.any? do |k|
        f.document["#{k}"].blank?
      end
    end
  end
end
