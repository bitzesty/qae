namespace :deadlines do
  desc "Update registration deadline to award switch deadline"
  task rename_registrations_opens_on_deadline: :environment do
    Deadline.where(kind: "registrations_open_on").update_all(kind: "award_year_switch")
  end
end
