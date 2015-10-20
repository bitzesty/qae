namespace :users_reports do

  desc "CSV of users for sending them a survey"
  task export_csv: :environment do
    output_directory = Rails.root.join('tmp').to_s

    CSV.open(Rails.root.join('tmp', "submitted.csv").to_s , "wb") do |submitted_csv|
      CSV.open(Rails.root.join('tmp', "not_submitted.csv").to_s , "wb") do |not_submitted_csv|
        CSV.open(Rails.root.join('tmp', "ep_submitted.csv").to_s , "wb") do |ep_submitted_csv|
          CSV.open(Rails.root.join('tmp', "ep_not_submitted.csv").to_s , "wb") do |ep_not_submitted_csv|
            User.includes(:form_answers).find_each do |user|
              if user.form_answers.select{|f| f.award_type == "promotion" }.any?
                if user.form_answers.select{|f| f.award_type == "promotion" && f.submitted? }.any?
                  ep_submitted_csv << [user.email, user.first_name, user.last_name]
                else
                  ep_not_submitted_csv << [user.email, user.first_name, user.last_name]
                end
              else
                if user.form_answers.select{|f| f.award_type != "promotion" && f.submitted? }.any?
                  submitted_csv << [user.email, user.first_name, user.last_name]
                else
                  not_submitted_csv << [user.email, user.first_name, user.last_name]
                end
              end
            end
          end
        end
      end
    end
  end
end
