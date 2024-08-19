require "rails_helper"

describe FinancialSummaryPointer do
  let(:partitioned_hash) do
    {
      nil => [:employees, :total_turnover, :exports, :net_profit, :total_net_assets],
      :innovation_financials => [:sales, :sales_exports, :sales_royalties],
    }
  end

  let(:form_answer) { create :form_answer, :trade, :submitted }

  describe "#summary_data" do
    context "financial years have changed and product introduction date > company incorporation date" do
      let(:data) do
        [
          {
            financial_year_changed_dates: [
              ["07", "07", "2021"],
              ["06", "09", "2022"],
            ],
          },
          { employees: [
            { value: "10", name: "employees_1of2" },
            { value: "12", name: "employees_2of2" },
          ],
          },
          {
            sales: [
              { value: "10", name: "sales_1of4" },
              { value: "10", name: "sales_2of4" },
              { value: "10", name: "sales_3of4" },
              { value: "10", name: "sales_4of4" },
            ],
          },
        ]
      end

      it "creates correct data summary with filled dates" do
        pointer = FinancialSummaryPointer.new(form_answer)

        allow(pointer).to receive(:data) { data }
        allow(pointer).to receive(:partitioned_hash) { partitioned_hash }

        expect(pointer.summary_data).to eq(
          [
            { dates: [nil, nil, "07/07/2021", "06/09/2022"] },
            { employees: [
              { name: nil, value: nil },
              { name: nil, value: nil },
              { name: "employees_1of2", value: "10" },
              { name: "employees_2of2", value: "12" },
            ] },
            { dates: ["07/07/2019", "07/07/2020", "07/07/2021", "06/09/2022"] },
            { sales: [
              { name: "sales_1of4", value: "10" },
              { name: "sales_2of4", value: "10" },
              { name: "sales_3of4", value: "10" },
              { name: "sales_4of4", value: "10" },
            ] },
          ],
        )
      end
    end

    context "financial years have changed and product introduction date < company incorporation date" do
      let(:data) do
        [
          {
            financial_year_changed_dates: [
              ["05", "05", "2019"],
              ["06", "06", "2020"],
              ["07", "07", "2021"],
              ["08", "08", "2022"],
            ],
          },
          { employees: [
            { value: "10", name: "employees_1of4" },
            { value: "10", name: "employees_2of4" },
            { value: "10", name: "employees_3of4" },
            { value: "10", name: "employees_4of4" },
          ],
          },
          {
            sales: [
              { value: "10", name: "sales_1of2" },
              { value: "10", name: "sales_2of2" },
            ],
          },
        ]
      end

      it "creates correct data summary with filled dates" do
        pointer = FinancialSummaryPointer.new(form_answer)

        allow(pointer).to receive(:data) { data }
        allow(pointer).to receive(:partitioned_hash) { partitioned_hash }

        expect(pointer.summary_data).to eq(
          [
            { dates: ["05/05/2019", "06/06/2020", "07/07/2021", "08/08/2022"] },
            { employees: [
              { name: "employees_1of4", value: "10" },
              { name: "employees_2of4", value: "10" },
              { name: "employees_3of4", value: "10" },
              { name: "employees_4of4", value: "10" },
            ] },
            { dates: [nil, nil, "07/07/2021", "08/08/2022"] },
            { sales: [
              { name: nil, value: nil },
              { name: nil, value: nil },
              { name: "sales_1of2", value: "10" },
              { name: "sales_2of2", value: "10" },
            ] },
          ],
        )
      end
    end

    context "financial years have NOT changed and product introduction date > company incorporation date" do
      let(:data) do
        [
          { employees: [
            { value: "10", name: "employees_1of2" },
            { value: "12", name: "employees_2of2" },
          ],
          },
          {
            sales: [
              { value: "10", name: "sales_1of4" },
              { value: "10", name: "sales_2of4" },
              { value: "10", name: "sales_3of4" },
              { value: "10", name: "sales_4of4" },
            ],
          },
        ]
      end

      it "creates correct data summary with filled dates" do
        pointer = FinancialSummaryPointer.new(form_answer)

        allow(pointer).to receive(:data) { data }
        allow(pointer).to receive(:partitioned_hash) { partitioned_hash }
        allow(pointer).to receive(:fetch_financial_year_dates) { [["02/01/2022", "02/01/2023"], false] }

        expect(pointer.summary_data).to eq(
          [
            { dates: [nil, nil, "02/01/2022", "02/01/2023"] },
            { employees: [
              { name: nil, value: nil },
              { name: nil, value: nil },
              { name: "employees_1of2", value: "10" },
              { name: "employees_2of2", value: "12" },
            ] },
            { dates: ["02/01/2020", "02/01/2021", "02/01/2022", "02/01/2023"] },
            { sales: [
              { name: "sales_1of4", value: "10" },
              { name: "sales_2of4", value: "10" },
              { name: "sales_3of4", value: "10" },
              { name: "sales_4of4", value: "10" },
            ] },
          ],
        )
      end

      it "creates correct data summary with filled dates" do
        pointer = FinancialSummaryPointer.new(form_answer)

        allow(pointer).to receive(:data) { data }
        allow(pointer).to receive(:partitioned_hash) { partitioned_hash }
        allow(pointer).to receive(:fetch_financial_year_dates) { [["02/01/2022", "02/01/2023"], false] }

        expect(pointer.summary_data).to eq(
          [
            { dates: [nil, nil, "02/01/2022", "02/01/2023"] },
            { employees: [
              { name: nil, value: nil },
              { name: nil, value: nil },
              { name: "employees_1of2", value: "10" },
              { name: "employees_2of2", value: "12" },
            ] },
            { dates: ["02/01/2020", "02/01/2021", "02/01/2022", "02/01/2023"] },
            { sales: [
              { name: "sales_1of4", value: "10" },
              { name: "sales_2of4", value: "10" },
              { name: "sales_3of4", value: "10" },
              { name: "sales_4of4", value: "10" },
            ] },
          ],
        )
      end

      it "handles leap years" do
        pointer = FinancialSummaryPointer.new(form_answer)

        allow(pointer).to receive(:data) { data }
        allow(pointer).to receive(:partitioned_hash) { partitioned_hash }
        allow(pointer).to receive(:fetch_financial_year_dates) { [["29/02/2024", "01/05/2025"], false] }

        expect(pointer.summary_data).to eq(
          [
            { dates: [nil, nil, "29/02/2024", "01/05/2025"] },
            { employees: [
              { name: nil, value: nil },
              { name: nil, value: nil },
              { name: "employees_1of2", value: "10" },
              { name: "employees_2of2", value: "12" },
            ] },
            { dates: ["28/02/2022", "28/02/2023", "29/02/2024", "01/05/2025"] },
            { sales: [
              { name: "sales_1of4", value: "10" },
              { name: "sales_2of4", value: "10" },
              { name: "sales_3of4", value: "10" },
              { name: "sales_4of4", value: "10" },
            ] },
          ],
        )
      end
    end

    context "financial years have NOT changed and product introduction date < company incorporation date" do
      let(:data) do
        [
          { employees: [
            { value: "10", name: "employees_1of4" },
            { value: "10", name: "employees_2of4" },
            { value: "10", name: "employees_3of4" },
            { value: "10", name: "employees_4of4" },
          ],
          },
          {
            sales: [
              { value: "10", name: "sales_1of2" },
              { value: "10", name: "sales_2of2" },
            ],
          },
        ]
      end
    end
  end
end
