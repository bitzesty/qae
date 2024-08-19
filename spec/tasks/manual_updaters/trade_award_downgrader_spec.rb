require "rails_helper"

describe ManualUpdaters::TradeAwardDowngrader do
  context "with invalid input" do
    it "raises the error if the application is missing" do
      expect { described_class.new(nil).run! }.to raise_error(ArgumentError, "You must provide an application")
    end

    it "raises the error if the application is not a trade application" do
      expect { described_class.new(build(:form_answer, :development)).run! }.to raise_error(ArgumentError, "You must provide trade application")
    end

    it "raises the error if the application is not a trade application" do
      form_answer = build(:form_answer, :trade)
      form_answer.document = form_answer.document.merge("trade_commercial_success" => "3 to 5")

      expect { described_class.new(form_answer).run! }.to raise_error(ArgumentError, "Application is already 3 to 5 years")
    end
  end

  context "with valid input" do
    let(:form_answer) { create(:form_answer, :trade, :submitted) }

    it "changes financial period and all related data", :aggregate_failures do
      document = form_answer.document.dup

      document["trade_commercial_success"] = "6 plus"

      6.times do |i|
        document["employees_#{i + 1}of6"] = i + 1
      end

      %w[day month].each do |attr|
        5.times do |i|
          document["financial_year_changed_dates_#{i + 1}of6#{attr}"] = i + 1
        end
      end

      %w[overseas_sales total_turnover net_profit].each do |attr|
        6.times do |i|
          document["#{attr}_#{i + 1}of6"] = 100000 + i + 1
        end
      end

      form_answer.document = document
      form_answer.save!

      described_class.new(form_answer).run!

      form_answer.reload
      document = form_answer.document

      3.times do |i|
        expect(document["employees_#{i + 1}of3"]).to eq(i + 4)
      end

      %w[day month].each do |attr|
        2.times do |i|
          expect(document["financial_year_changed_dates_#{i + 1}of3#{attr}"]).to eq(i + 4)
        end
      end

      %w[overseas_sales total_turnover net_profit].each do |attr|
        3.times do |i|
          expect(document["#{attr}_#{i + 1}of3"]).to eq(100000 + i + 4)
        end
      end
    end
  end
end
