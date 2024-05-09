require "rails_helper"

describe UkSalesCalculator do
  let(:total_turnover) do
    { total_turnover: [
      { value: "1000", name: "total_turnover_1of5" },
      { value: "1100", name: "total_turnover_2of5" },
      { value: "1210", name: "total_turnover_3of5" },
      { value: "1300", name: "total_turnover_4of5" },
      { value: "1300", name: "total_turnover_5of5" },
    ],
    }
  end

  let(:exports_data) do
    [
      { exports: [
        { value: "0", name: "exports_1of5" },
        { value: "100", name: "exports_2of5" },
        { value: "200", name: "exports_3of5" },
        { value: "300", name: "exports_4of5" },
        { value: "350", name: "exports_5of5" },
      ],
      },
      total_turnover,
    ]
  end

  let(:overseas_data) do
    [
      { overseas_sales: [
        { value: "0", name: "exports_1of5" },
        { value: "100", name: "exports_2of5" },
        { value: "200", name: "exports_3of5" },
        { value: "300", name: "exports_4of5" },
        { value: "350", name: "exports_5of5" },
      ],
      },
      total_turnover,
    ]
  end

  it "returns calculated form exports UK sales" do
    calculator = UkSalesCalculator.new(exports_data)
    expected = [1000.0, 1000.0, 1010.0, 1000.0, 950.0]

    expect(calculator.data[:uk_sales]).to eq(expected)
  end

  it "returns calculated from overseas sales UK sales" do
    calculator = UkSalesCalculator.new(overseas_data)
    expected = [1000.0, 1000.0, 1010.0, 1000.0, 950.0]

    expect(calculator.data[:uk_sales]).to eq(expected)
  end
end
