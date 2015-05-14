require "rails_helper"

describe PerformancePlatformService do
  describe ".run" do
    it "performs 2 requests" do
      expect(described_class).to receive(:perform_transactions_by_channel)
      expect(described_class).to receive(:perform_applications_by_stage)

      described_class.run
    end
  end

  describe ".perform_transactions_by_channel" do
    it "collects data and tries to perform request" do
      answer = create(:form_answer)
      answer.update_column(:created_at, Time.current - 1.week)
      timestamp = (Time.current - 1.week).beginning_of_day.utc.iso8601

      id = described_class.md5("#{timestamp}weekonlinedigital")

      expected = {
        "period" => "week",
        "channel" => "online",
        "channel_type" => "digital",
        "count" => 1,
        "_timestamp" => timestamp,
        "_id" => id
      }

      url = "https://www.performance.service.gov.uk/data/queens-awards-for-enterprise/transactions-by-channel"
      expect(described_class).to receive(:perform_request).with(url, [expected])
      described_class.perform_transactions_by_channel
    end
  end

  describe ".perform_applications_by_stage" do
    it "collects data and tries to perform request" do
      url = "https://www.performance.service.gov.uk/data/queens-awards-for-enterprise/applications-by-stage"
      expect(described_class).to receive(:fetch_applications_data) { "somedata" }
      expect(described_class).to receive(:perform_request).with(url, "somedata")
      described_class.perform_applications_by_stage
    end
  end

  describe ".fetch_applications_report" do
    it "collects the data" do
      answer_1 = create(:form_answer, :trade)
      answer_1.update_column(:created_at, Time.current - 1.week)
      answer_1.update_column(:fill_progress, nil)
      answer_2 = create(:form_answer, :promotion)
      answer_2.update_column(:created_at, Time.current - 10.days)
      answer_2.update_column(:fill_progress, 83)
      answer_3 = create(:form_answer, :promotion)
      answer_3.update_column(:created_at, Time.current - 2.days)
      answer_3.update_column(:fill_progress, 75)
      timestamp = (Time.current - 1.week).beginning_of_day.utc.iso8601

      id_1 = described_class.md5("#{timestamp}weekinternational-trade0-percent")
      id_2 = described_class.md5("#{timestamp}weekqaep75-99-percent")

      report_1 = {
        "period" => "week",
        "stage" => "0-percent",
        "award" => "international-trade",
        "count" => 1,
        "_timestamp" => timestamp,
        "_id" => id_1
      }

      report_2 = {
        "period" => "week",
        "stage" => "75-99-percent",
        "award" => "qaep",
        "count" => 2,
        "_timestamp" => timestamp,
        "_id" => id_2
      }

      expect(described_class.fetch_applications_data).to include(report_1)
      expect(described_class.fetch_applications_data).to include(report_2)
    end
  end
end
