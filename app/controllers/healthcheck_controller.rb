class HealthcheckController < Api::BaseController
  def index
    checked = {
      database: check_database,
      # migrations: check_migrations,
      # cache: check_cache,
      redis: check_redis,
    }

    @status = (checked.values.all? { |result| result[:success] }) ? "OK" : "FALSE"
    @comments = checked.reject { |_, result| result[:success] }
                       .map { |name, result| "#{name.to_s.capitalize} check failed: #{result[:message]}" }
    Rails.logger.info("Healthcheck status: #{@status}")

    render xml: build_xml, status: (@status == "OK") ? :ok : :internal_server_error
  end

  private

  def build_xml
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
    xml.pingdom_http_custom_check do
      xml.status do
        xml.strong @status
      end
      xml.response_time do
        xml.strong calculate_response_time
      end
      @comments&.each do |comment|
        xml.comment! comment
      end
    end
    xml.target!
  end

  def calculate_response_time
    Thread.current[:response_time] || "-"
  end

  def check_database
    ActiveRecord::Base.connection.execute("select 1")
    { success: true }
  rescue => e
    { success: false, message: e.message }
  end

  # Skipping for now, as we need to determin how migrations will be deployed
  def check_migrations
    ActiveRecord::Migration.check_pending!
    { success: true }
  rescue => e
    { success: false, message: e.message }
  end

  # Skipping for now, as they use the same redis instance
  def check_cache
    Rails.cache.read("some_key")
    { success: true }
  rescue => e
    { success: false, message: e.message }
  end

  def check_redis
    Redis.new(url: PaasResolver.redis_uri).ping
    { success: true }
  rescue => e
    { success: false, message: e.message }
  end
end
