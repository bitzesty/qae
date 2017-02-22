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
      self.all_apps = year.form_answers.where("state NOT IN (?)", ["eligibility_in_progress", "not_eligible"])

      self.trade_apps = all_apps.where(award_type: "trade")
      self.innovation_apps = all_apps.where(award_type: "innovation")
      self.development_apps = all_apps.where(award_type: "development")
      self.mobility_apps = all_apps.where(award_type: "mobility")
    end

    def run
      puts ""

      self.wrong_trade_apps = trade_apps.select do |app|
        !app.eligible?
      end

      puts "[TRADE]                    #{wrong_trade_apps.count}"
      puts ""

      wrong_trade_apps.map do |app|
        puts "   [#{app.id} | #{app.urn}] STATE: #{app.state}, SUBMITTED: #{app.submitted?}"
      end

      puts ""

      self.wrong_innovation_apps = innovation_apps.select do |app|
        !app.eligible?
      end

      puts "[INNOVATION]                    #{wrong_innovation_apps.count}"
      puts ""

      wrong_innovation_apps.map do |app|
        puts "   [#{app.id} | #{app.urn}] STATE: #{app.state}, SUBMITTED: #{app.submitted?}"
      end

      puts ""

      self.wrong_development_apps = development_apps.select do |app|
        !app.eligible?
      end

      puts "[DEVELOPMENT]                    #{wrong_development_apps.count}"
      puts ""

      wrong_development_apps.map do |app|
        puts "   [#{app.id} | #{app.urn}] STATE: #{app.state}, SUBMITTED: #{app.submitted?}"
      end
      puts ""

      self.wrong_mobility_apps = mobility_apps.select do |app|
        !app.eligible?
      end

      puts "[MOBILITY]                    #{wrong_mobility_apps.count}"
      puts ""

      wrong_mobility_apps.map do |app|
        puts "   [#{app.id} | #{app.urn}] STATE: #{app.state}, SUBMITTED: #{app.submitted?}"
      end
      puts ""
    end
  end
end
