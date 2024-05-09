require "rails_helper"

describe FormFinancialPointer do
  let(:trade_data) do
    [
      {
        employees: [
          { value: "1", name: "employees_1of6" },
          { value: "2", name: "employees_2of6" },
          { value: "3", name: "employees_3of6" },
          { value: "4", name: "employees_4of6" },
          { value: "5", name: "employees_5of6" },
          { value: "6", name: "employees_6of6" },
                   ],
      },
      {
        overseas_sales: [
          { value: "30", name: "overseas_sales_1of6" },
          { value: "40", name: "overseas_sales_2of6" },
          { value: "50", name: "overseas_sales_3of6" },
          { value: "60", name: "overseas_sales_4of6" },
          { value: "70", name: "overseas_sales_5of6" },
          { value: "80", name: "overseas_sales_6of6" },
                        ],
      },
      {
        total_turnover: [
          { value: "100", name: "total_turnover_1of6" },
          { value: "120", name: "total_turnover_2of6" },
          { value: "120", name: "total_turnover_3of6" },
          { value: "130", name: "total_turnover_4of6" },
          { value: "120", name: "total_turnover_5of6" },
          { value: "150", name: "total_turnover_6of6" },
                        ],
      },
      {
        net_profit: [
          { value: "10", name: "net_profit_1of6" },
          { value: "10", name: "net_profit_2of6" },
          { value: "15", name: "net_profit_3of6" },
          { value: "15", name: "net_profit_4of6" },
          { value: "20", name: "net_profit_5of6" },
          { value: "30", name: "net_profit_6of6" },
                    ],
      },
    ]
  end

  let(:innovation_data) do
    [
      { employees: [
        { value: "10", name: "employees_1of5" },
        { value: "12", name: "employees_2of5" },
        { value: "12", name: "employees_3of5" },
        { value: "15", name: "employees_4of5" },
        { value: "18", name: "employees_5of5" },
                   ],
      },
      { total_turnover: [
        { value: "1000", name: "total_turnover_1of5" },
        { value: "1100", name: "total_turnover_2of5" },
        { value: "1200", name: "total_turnover_3of5" },
        { value: "1300", name: "total_turnover_4of5" },
        { value: "1300", name: "total_turnover_5of5" },
                        ],
      },
      { exports: [
        { value: "0", name: "exports_1of5" },
        { value: "100", name: "exports_2of5" },
        { value: "200", name: "exports_3of5" },
        { value: "300", name: "exports_4of5" },
        { value: "300", name: "exports_5of5" },
                 ],
      },
      { net_profit: [
        { value: "800", name: "net_profit_1of5" },
        { value: "880", name: "net_profit_2of5" },
        { value: "900", name: "net_profit_3of5" },
        { value: "1000", name: "net_profit_4of5" },
        { value: "1000", name: "net_profit_5of5" },
                    ],
      },
      { total_net_assets: [
        { value: "10000", name: "total_net_assets_1of5" },
        { value: "11000", name: "total_net_assets_2of5" },
        { value: "12000", name: "total_net_assets_3of5" },
        { value: "15000", name: "total_net_assets_4of5" },
        { value: "20000", name: "total_net_assets_5of5" },
                           ],
      },
    ]
  end

  let(:form_answer) { create :form_answer, :trade, :submitted }

  it "benchmarks trade data" do
    pointer = FormFinancialPointer.new(form_answer)
    allow(pointer).to receive(:data) { trade_data }

    expected_growth_overseas_earnings = ["-", 33.33, 25, 20, 16.67, 14.29]
    expected_sales_exported = [30, 33.33, 41.67, 46.15, 58.33, 53.33]

    6.times do |year|
      expect(pointer.growth_overseas_earnings(year)).to eq(expected_growth_overseas_earnings[year])
      expect(pointer.sales_exported(year)).to eq(expected_sales_exported[year])
    end
  end

  it "benchmarks innovation data" do
    pointer = FormFinancialPointer.new(form_answer)
    allow(pointer).to receive(:data) { innovation_data }

    expected_growth_in_total_turnover = ["-", 10, 9.09, 8.33, 0]

    5.times do |year|
      expect(pointer.growth_in_total_turnover(year)).to eq(expected_growth_in_total_turnover[year])
    end
  end
end
