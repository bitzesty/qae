namespace :users_reports do

  desc "CSV of users for sending them a survey"
  task export_csv: :environment do
    output_directory = Rails.root.join('tmp').to_s

    CSV.open(Rails.root.join('tmp', "submitted.csv").to_s , "wb") do |submitted_csv|
      CSV.open(Rails.root.join('tmp', "not_submitted.csv").to_s , "wb") do |not_submitted_csv|
        User.includes(:form_answers).find_each do |user|
          if user.form_answers.for_year(2022).submitted.any?
            submitted_csv << [user.email, user.first_name, user.last_name]
          elsif user.form_answers.for_year(2022).any?
            not_submitted_csv << [user.email, user.first_name, user.last_name]
          end
        end
      end
    end
  end
end
