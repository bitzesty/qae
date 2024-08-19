require "json"
require "net/http"
require "digest"

class PerformancePlatformService
  TRANSACTIONS_BY_CHANNEL_URL = "https://www.performance.service.gov.uk/data/queens-awards-for-enterprise/transactions-by-channel"
  APPLICATIONS_BY_STAGE_URL = "https://www.performance.service.gov.uk/data/queens-awards-for-enterprise/applications-by-stage"

  AWARD_TYPE_MAPPING = {
    "trade" => "international-trade",
    "innovation" => "innovation",
    "development" => "sustainable-development",
    "promotion" => "qaep",
  }

  POSSIBLE_RANGES = [
    "100-percent",
    "75-99-percent",
    "50-74-percent",
    "25-49-percent",
    "1-24-percent",
    "0-percent",
  ]

  def self.run
    log_this("started") unless Rails.env.test?

    perform_transactions_by_channel
    perform_applications_by_stage

    log_this("completed") unless Rails.env.test?
  end

  # [
  #  {
  #      "_id": "23456780",
  #      "_timestamp": "2015-03-10T00:00:00Z",
  #      "period": "week",
  #      "channel": "online",
  #      "channel_type": "digital",
  #      "count": 42
  #  }
  # ]
  def self.perform_transactions_by_channel
    timestamp = (Time.current - 1.week).beginning_of_day.utc

    form_answers_count = form_answers_for_past_week.submitted.count

    result = {
      "period" => "week",
      "channel" => "online",
      "channel_type" => "digital",
      "count" => form_answers_count,
      "_timestamp" => timestamp.iso8601,
    }

    result["_id"] = generate_transactions_id(result)

    perform_request(TRANSACTIONS_BY_CHANNEL_URL, [result])
  end

  # [
  #  {
  #      "_id": "23456789",
  #      "_timestamp": "2015-03-18T00:00:00Z",
  #      "period": "week",
  #      "award": "qaep",
  #      "stage": "1-24-percent",
  #      "count": 23,
  #      "cumulative_count": 30
  #  },
  #  {
  #      "_id": "23456780",
  #      "_timestamp": "2015-03-10T00:00:00Z",
  #      "period": "week",
  #      "award": "qaep",
  #      "stage": "0-percent",
  #      "count": 42,
  #      "cumulative_count": 72
  #  }
  # ]

  def self.perform_applications_by_stage
    payload = fetch_applications_data

    perform_request(APPLICATIONS_BY_STAGE_URL, payload)
  end

  def self.perform_request(url, payload)
    if ENV["PERFORMANCE_PLATFORM_TOKEN"].present?

      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["PERFORMANCE_PLATFORM_TOKEN"]}",
      }

      uri = URI(url)
      req = Net::HTTP::Post.new(uri.path, headers)

      req.body = payload.to_json

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :SSLv3
        http.request req
      end

      Rails.logger.debug res.body

      nil
    end
  end

  def self.fetch_applications_data
    result = []
    timestamp = (Time.current - 1.week).beginning_of_day.utc

    AWARD_TYPE_MAPPING.each do |award_type, award|
      POSSIBLE_RANGES.each do |stage|
        case stage
        when "0-percent"
          count = form_answers
            .where("fill_progress IS NULL OR fill_progress = 0")
            .where(award_type: award_type)
            .count

          cumulative_count = form_answers
            .where("fill_progress IS NULL OR fill_progress >= 0 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count
        when "1-24-percent"
          count = form_answers
            .where("fill_progress > 0 AND fill_progress < 25")
            .where(award_type: award_type)
            .count

          cumulative_count = form_answers
            .where("fill_progress > 0 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count
        when "25-49-percent"
          count = form_answers
            .where("fill_progress >= 25 AND fill_progress < 50")
            .where(award_type: award_type)
            .count

          cumulative_count = form_answers
            .where("fill_progress >= 25 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count
        when "50-74-percent"
          count = form_answers
            .where("fill_progress >= 50 AND fill_progress < 75")
            .where(award_type: award_type)
            .count

          cumulative_count = form_answers
            .where("fill_progress >= 50 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count
        when "75-99-percent"
          count = form_answers
            .where("fill_progress >= 75 AND fill_progress < 100")
            .where(award_type: award_type)
            .count

          cumulative_count = form_answers
            .where("fill_progress >= 50 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count
        when "100-percent"
          count = form_answers
            .where("fill_progress = 100 OR submitted_at IS NOT NULL")
            .where(award_type: award_type)
            .count

          cumulative_count = count
        end

        data = {
          "_timestamp" => timestamp.iso8601,
          "period" => "week",
          "award" => award,
          "stage" => stage,
          "count" => count,
          "cumulative_count" => cumulative_count,
        }

        data["_id"] = generate_applications_id(data)

        result << data
      end
    end

    result
  end

  # "A SHA256 encoded concatenation of: _timestamp, period, channel, channel_type, (the dimensions of the data point)"
  def self.generate_transactions_id(data)
    string = ""

    %w[_timestamp period channel channel_type].each do |attr|
      string << data[attr]
    end

    md5(string)
  end

  # "A SHA256 encoded concatenation of: _timestamp, period, award, stage, i.e. (the dimensions of the data point)"
  def self.generate_applications_id(data)
    string = ""

    %w[_timestamp period award stage].each do |attr|
      string << data[attr]
    end

    md5(string)
  end

  def self.form_answers_for_past_week
    AwardYear.current.form_answers
      .where("created_at >= ?", (Time.current - 1.week).beginning_of_day)
      .where("created_at < ?", Time.current.beginning_of_day)
  end

  def self.form_answers
    AwardYear.current.form_answers
  end

  def self.md5(string)
    md5 = Digest::MD5.new
    md5.update(string)

    md5.hexdigest
  end

  class << self
    def log_this(message)
      Rails.logger.debug "[PerformancePlatformService] #{Time.zone.now} #{message}"
    end
  end
end
