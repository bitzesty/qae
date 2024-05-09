namespace :users_reports do
  desc "CSV of users for sending them a survey"
  task :export_csv, [:year] => :environment do |task, args|
    output_directory = Rails.root.join("tmp").to_s

    CSV.open(Rails.root.join("tmp", "submitted.csv").to_s , "wb") do |submitted_csv|
      CSV.open(Rails.root.join("tmp", "not_submitted.csv").to_s , "wb") do |not_submitted_csv|
        User.includes(:form_answers).find_each do |user|
          if user.form_answers.for_year(args[:year]).submitted.any?
            submitted_csv << [user.email, user.first_name, user.last_name]
          elsif user.form_answers.for_year(args[:year]).any?
            not_submitted_csv << [user.email, user.first_name, user.last_name]
          end
        end
      end
    end
  end

  desc "Export user emails and names to CSV for collaborators on recommended current year applications"
  task export_collaborators_csv: :environment do
    CSV.open("collaborators.csv", "w") do |csv|
      csv << ["Email", "Name", "URN"]

      FormAnswer.where(award_year: AwardYear.current).shortlisted.each do |form_answer|
        form_answer.collaborators.each do |user|
          csv << [user.email, "#{user.title} #{user.last_name}", form_answer.urn]
        end
      end
    end

    puts "Collaborator CSV export complete - collaborators.csv generated"
  end
end
