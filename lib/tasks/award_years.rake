namespace :award_years do
  desc "Ensures deadlines are set for award years"
  task ensure_deadlines: :environment do
    AwardYear.find_each do |award_year|
      award_year.settings.send :create_deadlines
    end
  end
end
