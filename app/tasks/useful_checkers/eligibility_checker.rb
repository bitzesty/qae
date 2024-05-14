#
# UsefulCheckers::EligibilityChecker.new.run
#

module UsefulCheckers
  class EligibilityChecker
    attr_accessor :year,
      :all_apps,
      :trade_apps,
      :innovation_apps,
      :development_apps,
      :mobility_apps,
      :wrong_trade_apps,
      :wrong_innovation_apps,
      :wrong_development_apps,
      :wrong_mobility_apps

    def initialize
      ActiveRecord::Base.logger.level = Logger::INFO

      self.year = AwardYear.current
      self.all_apps = year.form_answers.where.not(state: ["eligibility_in_progress", "not_eligible", "not_submitted"])

      self.trade_apps = all_apps.where(award_type: "trade")
      self.innovation_apps = all_apps.where(award_type: "innovation")
      self.development_apps = all_apps.where(award_type: "development")
      self.mobility_apps = all_apps.where(award_type: "mobility")
    end

    def run
      Rails.logger.debug ""

      self.wrong_trade_apps = trade_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      Rails.logger.debug "[TRADE] #{wrong_trade_apps.count} entries"
      Rails.logger.debug ""

      wrong_trade_apps.map do |app|
        details(app)
      end

      Rails.logger.debug ""

      self.wrong_innovation_apps = innovation_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      Rails.logger.debug "[INNOVATION] #{wrong_innovation_apps.count} entries"
      Rails.logger.debug ""

      wrong_innovation_apps.map do |app|
        details(app)
      end

      Rails.logger.debug ""

      self.wrong_development_apps = development_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      Rails.logger.debug "[DEVELOPMENT] #{wrong_development_apps.count} entries"
      Rails.logger.debug ""

      wrong_development_apps.map do |app|
        details(app)
      end
      Rails.logger.debug ""

      self.wrong_mobility_apps = mobility_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      Rails.logger.debug "[MOBILITY] #{wrong_mobility_apps.count} entries"
      Rails.logger.debug ""

      wrong_mobility_apps.map do |app|
        details(app)
      end
      Rails.logger.debug ""
    end

    def details(app)
      b = app.form_basic_eligibility
      e = app.eligibility
      e.force_validate_now = true
      e.valid?

      Rails.logger.debug "   [#{app.id} | #{app.award_type}] STATE: #{app.state}"
      Rails.logger.debug ""
      Rails.logger.debug "        BASIC ELIGIBILITY"
      Rails.logger.debug ""
      b.answers.map do |k, v|
        Rails.logger.debug "        #{k}: #{v}"
      end
      Rails.logger.debug ""
      Rails.logger.debug "        #{app.award_type.upcase} ELIGIBILITY"
      Rails.logger.debug ""
      e.answers.map do |k, v|
        Rails.logger.debug "        #{k}: #{v}"
      end
      Rails.logger.debug ""
      Rails.logger.debug "        #{e.errors.full_messages.join(", ")}"
      Rails.logger.debug ""
    end
  end
end
