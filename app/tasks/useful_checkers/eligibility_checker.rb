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
      puts ""

      self.wrong_trade_apps = trade_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      puts "[TRADE] #{wrong_trade_apps.count} entries"
      puts ""

      wrong_trade_apps.map do |app|
        details(app)
      end

      puts ""

      self.wrong_innovation_apps = innovation_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      puts "[INNOVATION] #{wrong_innovation_apps.count} entries"
      puts ""

      wrong_innovation_apps.map do |app|
        details(app)
      end

      puts ""

      self.wrong_development_apps = development_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      puts "[DEVELOPMENT] #{wrong_development_apps.count} entries"
      puts ""

      wrong_development_apps.map do |app|
        details(app)
      end
      puts ""

      self.wrong_mobility_apps = mobility_apps.select do |app|
        e = app.eligibility
        e.force_validate_now = true

        !e.valid?
      end

      puts "[MOBILITY] #{wrong_mobility_apps.count} entries"
      puts ""

      wrong_mobility_apps.map do |app|
        details(app)
      end
      puts ""
    end

    def details(app)
      b = app.form_basic_eligibility
      e = app.eligibility
      e.force_validate_now = true
      e.valid?

      puts "   [#{app.id} | #{app.award_type}] STATE: #{app.state}"
      puts ""
      puts "        BASIC ELIGIBILITY"
      puts ""
      b.answers.map do |k, v|
        puts "        #{k}: #{v}"
      end
      puts ""
      puts "        #{app.award_type.upcase} ELIGIBILITY"
      puts ""
      e.answers.map do |k, v|
        puts "        #{k}: #{v}"
      end
      puts ""
      puts "        #{e.errors.full_messages.join(", ")}"
      puts ""
    end
  end
end
