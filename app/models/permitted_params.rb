module PermittedParams
  FINANCIAL_DATA = %i[
    avg_unit_cost_self_1of2
    avg_unit_cost_self_1of3
    avg_unit_cost_self_1of4
    avg_unit_cost_self_1of5
    avg_unit_cost_self_1of6
    avg_unit_cost_self_2of2
    avg_unit_cost_self_2of3
    avg_unit_cost_self_2of4
    avg_unit_cost_self_2of5
    avg_unit_cost_self_2of6
    avg_unit_cost_self_3of3
    avg_unit_cost_self_3of4
    avg_unit_cost_self_3of5
    avg_unit_cost_self_3of6
    avg_unit_cost_self_4of4
    avg_unit_cost_self_4of5
    avg_unit_cost_self_4of6
    avg_unit_cost_self_5of5
    avg_unit_cost_self_5of6
    avg_unit_cost_self_6of6
    avg_unit_price_1of2
    avg_unit_price_1of3
    avg_unit_price_1of4
    avg_unit_price_1of5
    avg_unit_price_1of6
    avg_unit_price_2of2
    avg_unit_price_2of3
    avg_unit_price_2of4
    avg_unit_price_2of5
    avg_unit_price_2of6
    avg_unit_price_3of3
    avg_unit_price_3of4
    avg_unit_price_3of5
    avg_unit_price_3of6
    avg_unit_price_4of4
    avg_unit_price_4of5
    avg_unit_price_4of6
    avg_unit_price_5of5
    avg_unit_price_5of6
    avg_unit_price_6of6
    employees_1of2
    employees_1of3
    employees_1of4
    employees_1of5
    employees_1of6
    employees_2of2
    employees_2of3
    employees_2of4
    employees_2of5
    employees_2of6
    employees_3of3
    employees_3of4
    employees_3of5
    employees_3of6
    employees_4of4
    employees_4of5
    employees_4of6
    employees_5of5
    employees_5of6
    employees_6of6
    exports_1of2
    exports_1of3
    exports_1of4
    exports_1of5
    exports_1of6
    exports_2of2
    exports_2of3
    exports_2of4
    exports_2of5
    exports_2of6
    exports_3of3
    exports_3of4
    exports_3of5
    exports_3of6
    exports_4of4
    exports_4of5
    exports_4of6
    exports_5of5
    exports_5of6
    exports_6of6
    financial_year_changed_dates_1of2day
    financial_year_changed_dates_1of2month
    financial_year_changed_dates_1of2year
    financial_year_changed_dates_1of3day
    financial_year_changed_dates_1of3month
    financial_year_changed_dates_1of3year
    financial_year_changed_dates_1of5day
    financial_year_changed_dates_1of5month
    financial_year_changed_dates_1of5year
    financial_year_changed_dates_1of6day
    financial_year_changed_dates_1of6month
    financial_year_changed_dates_1of6year
    financial_year_changed_dates_2of2day
    financial_year_changed_dates_2of2month
    financial_year_changed_dates_2of2year
    financial_year_changed_dates_2of3day
    financial_year_changed_dates_2of3month
    financial_year_changed_dates_2of3year
    financial_year_changed_dates_2of5day
    financial_year_changed_dates_2of5month
    financial_year_changed_dates_2of5year
    financial_year_changed_dates_2of6day
    financial_year_changed_dates_2of6month
    financial_year_changed_dates_2of6year
    financial_year_changed_dates_3of3day
    financial_year_changed_dates_3of3month
    financial_year_changed_dates_3of3year
    financial_year_changed_dates_3of5day
    financial_year_changed_dates_3of5month
    financial_year_changed_dates_3of5year
    financial_year_changed_dates_3of6day
    financial_year_changed_dates_3of6month
    financial_year_changed_dates_3of6year
    financial_year_changed_dates_4of5day
    financial_year_changed_dates_4of5month
    financial_year_changed_dates_4of5year
    financial_year_changed_dates_4of6day
    financial_year_changed_dates_4of6month
    financial_year_changed_dates_4of6year
    financial_year_changed_dates_5of5day
    financial_year_changed_dates_5of5month
    financial_year_changed_dates_5of5year
    financial_year_changed_dates_5of6day
    financial_year_changed_dates_5of6month
    financial_year_changed_dates_5of6year
    financial_year_changed_dates_6of6day
    financial_year_changed_dates_6of6month
    financial_year_changed_dates_6of6year
    net_profit_1of2
    net_profit_1of3
    net_profit_1of4
    net_profit_1of5
    net_profit_1of6
    net_profit_2of2
    net_profit_2of3
    net_profit_2of4
    net_profit_2of5
    net_profit_2of6
    net_profit_3of3
    net_profit_3of4
    net_profit_3of5
    net_profit_3of6
    net_profit_4of4
    net_profit_4of5
    net_profit_4of6
    net_profit_5of5
    net_profit_5of6
    net_profit_6of6
    overseas_sales_1of2
    overseas_sales_1of3
    overseas_sales_1of5
    overseas_sales_1of6
    overseas_sales_2of2
    overseas_sales_2of3
    overseas_sales_2of5
    overseas_sales_2of6
    overseas_sales_3of3
    overseas_sales_3of5
    overseas_sales_3of6
    overseas_sales_4of5
    overseas_sales_4of6
    overseas_sales_5of5
    overseas_sales_5of6
    overseas_sales_6of6
    overseas_yearly_percentage_1of3
    overseas_yearly_percentage_1of6
    overseas_yearly_percentage_2of3
    overseas_yearly_percentage_2of6
    overseas_yearly_percentage_3of3
    overseas_yearly_percentage_3of6
    overseas_yearly_percentage_4of6
    overseas_yearly_percentage_5of6
    overseas_yearly_percentage_6of6
    sales_1of2
    sales_1of3
    sales_1of4
    sales_1of5
    sales_1of6
    sales_2of2
    sales_2of3
    sales_2of4
    sales_2of5
    sales_2of6
    sales_3of3
    sales_3of4
    sales_3of5
    sales_3of6
    sales_4of4
    sales_4of5
    sales_4of6
    sales_5of5
    sales_5of6
    sales_6of6
    sales_exports_1of2
    sales_exports_1of3
    sales_exports_1of4
    sales_exports_1of5
    sales_exports_1of6
    sales_exports_2of2
    sales_exports_2of3
    sales_exports_2of4
    sales_exports_2of5
    sales_exports_2of6
    sales_exports_3of3
    sales_exports_3of4
    sales_exports_3of5
    sales_exports_3of6
    sales_exports_4of4
    sales_exports_4of5
    sales_exports_4of6
    sales_exports_5of5
    sales_exports_5of6
    sales_exports_6of6
    sales_royalties_1of2
    sales_royalties_1of3
    sales_royalties_1of4
    sales_royalties_1of5
    sales_royalties_1of6
    sales_royalties_2of2
    sales_royalties_2of3
    sales_royalties_2of4
    sales_royalties_2of5
    sales_royalties_2of6
    sales_royalties_3of3
    sales_royalties_3of4
    sales_royalties_3of5
    sales_royalties_3of6
    sales_royalties_4of4
    sales_royalties_4of5
    sales_royalties_4of6
    sales_royalties_5of5
    sales_royalties_5of6
    sales_royalties_6of6
    total_imported_cost_1of3
    total_imported_cost_1of6
    total_imported_cost_2of3
    total_imported_cost_2of6
    total_imported_cost_3of3
    total_imported_cost_3of6
    total_imported_cost_4of6
    total_imported_cost_5of6
    total_imported_cost_6of6
    total_net_assets_1of2
    total_net_assets_1of3
    total_net_assets_1of4
    total_net_assets_1of5
    total_net_assets_1of6
    total_net_assets_2of2
    total_net_assets_2of3
    total_net_assets_2of4
    total_net_assets_2of5
    total_net_assets_2of6
    total_net_assets_3of3
    total_net_assets_3of4
    total_net_assets_3of5
    total_net_assets_3of6
    total_net_assets_4of4
    total_net_assets_4of5
    total_net_assets_4of6
    total_net_assets_5of5
    total_net_assets_5of6
    total_net_assets_6of6
    total_turnover_1of2
    total_turnover_1of3
    total_turnover_1of4
    total_turnover_1of5
    total_turnover_1of6
    total_turnover_2of2
    total_turnover_2of3
    total_turnover_2of4
    total_turnover_2of5
    total_turnover_2of6
    total_turnover_3of3
    total_turnover_3of4
    total_turnover_3of5
    total_turnover_3of6
    total_turnover_4of4
    total_turnover_4of5
    total_turnover_4of6
    total_turnover_5of5
    total_turnover_5of6
    total_turnover_6of6
    uk_sales_1of2
    uk_sales_1of3
    uk_sales_1of5
    uk_sales_1of6
    uk_sales_2of2
    uk_sales_2of3
    uk_sales_2of5
    uk_sales_2of6
    uk_sales_3of3
    uk_sales_3of5
    uk_sales_3of6
    uk_sales_4of5
    uk_sales_4of6
    uk_sales_5of5
    uk_sales_5of6
    uk_sales_6of6
    units_sold_1of2
    units_sold_1of3
    units_sold_1of4
    units_sold_1of5
    units_sold_1of6
    units_sold_2of2
    units_sold_2of3
    units_sold_2of4
    units_sold_2of5
    units_sold_2of6
    units_sold_3of3
    units_sold_3of4
    units_sold_3of5
    units_sold_3of6
    units_sold_4of4
    units_sold_4of5
    units_sold_4of6
    units_sold_5of5
    units_sold_5of6
    units_sold_6of6
    updated_at
    updated_by_id
    updated_by_type
  ]

  FORM_ANSWER = [
    :company_or_nominee_name,
    :nominee_title,
    :sic_code,
    data_attributes: {},
  ]
end
