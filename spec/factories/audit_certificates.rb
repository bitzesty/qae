FactoryGirl.define do
  factory :audit_certificate do
    association :form_answer, factory: :form_answer
    attachment do
      Rack::Test::UploadedFile.new(
        File.join(
          Rails.root,'spec','support','file_samples','audit_certificate_sample.pdf'
        )
      )
    end

    attachment_scan_results "clean"
  end

  sequence :financial_data_sample do
    ActiveSupport::HashWithIndifferentAccess.new({
      applying_for: "organisation",
      company_name: "Bitzesty",
      sales_1of5: "10",
      sales_2of5: "11",
      sales_3of5: "12",
      sales_4of5: "13",
      sales_5of5: "14",
      exports_1of5: "10000",
      exports_2of5: "10000",
      exports_3of5: "10000",
      exports_4of5: "10000",
      exports_5of5: "10000",
      employees_1of5: "10",
      employees_2of5: "20",
      employees_3of5: "30",
      employees_4of5: "40",
      employees_5of5: "50",
      net_profit_1of5: "20000",
      net_profit_2of5: "20000",
      net_profit_3of5: "20000",
      net_profit_4of5: "20000",
      net_profit_5of5: "20000",
      units_sold_1of5: "5",
      units_sold_2of5: "6",
      units_sold_3of5: "7",
      units_sold_4of5: "8",
      units_sold_5of5: "9",
      innovation_part_of: "single_product_or_service",
      principal_business: "yes",
      sales_exports_1of5: "10",
      sales_exports_2of5: "10",
      sales_exports_3of5: "10",
      sales_exports_4of5: "10",
      sales_exports_5of5: "10",
      avg_unit_price_1of5: "10",
      avg_unit_price_2of5: "10",
      avg_unit_price_3of5: "10",
      avg_unit_price_4of5: "10",
      avg_unit_price_5of5: "10",
      total_turnover_1of5: "100000",
      total_turnover_2of5: "100000",
      total_turnover_3of5: "100000",
      total_turnover_4of5: "100000",
      total_turnover_5of5: "100000",
      sales_royalties_1of5: "10",
      sales_royalties_2of5: "10",
      sales_royalties_3of5: "10",
      sales_royalties_4of5: "10",
      sales_royalties_5of5: "10",
      total_net_assets_1of5: "30000",
      total_net_assets_2of5: "30000",
      total_net_assets_3of5: "30000",
      total_net_assets_4of5: "30000",
      total_net_assets_5of5: "30000",
      avg_unit_cost_self_1of5: "10",
      avg_unit_cost_self_2of5: "10",
      avg_unit_cost_self_3of5: "10",
      avg_unit_cost_self_4of5: "10",
      avg_unit_cost_self_5of5: "10",
      financial_year_date_day: "2",
      financial_year_date_month: "1",
      product_estimated_figures: "yes",
      financial_year_date_changed: "yes",
      innovation_performance_years: "5 plus",
      financial_year_changed_dates_1of5day: "01",
      financial_year_changed_dates_2of5day: "01",
      financial_year_changed_dates_3of5day: "1",
      financial_year_changed_dates_4of5day: "01",
      financial_year_changed_dates_1of5year: "2011",
      financial_year_changed_dates_2of5year: "2012",
      financial_year_changed_dates_3of5year: "2013",
      financial_year_changed_dates_4of5year: "2014",
      financial_year_changed_dates_1of2month: "",
      financial_year_changed_dates_1of5month: "01",
      financial_year_changed_dates_2of5month: "01",
      financial_year_changed_dates_3of5month: "1",
      financial_year_changed_dates_4of5month: "01"
    })
  end
end
