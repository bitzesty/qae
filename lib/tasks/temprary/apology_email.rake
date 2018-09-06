namespace :users do
  desc "Send out apology emails to users who got multiple email notifications on 05.09.2018"
  task send_apology_email: :environment do
    broken_application_id = 8042

    puts "Gathering data..."

    applications = AwardYear.find_by_year(2019)
                     .form_answers
                     .business
                     .where(submitted_at: nil)
                     .where("form_answers.id < ?", broken_application_id)

    user_ids = [].to_set

    applications.each do |form_answer|
      form_answer.collaborators.each do |user|
        user_ids << user.id
      end
    end

    user_ids.each do |user_id|
      puts "Sending to #{user_id}"
      Users::ApologyMailer.notify(user_id).deliver_later!
    end

    puts "Done"
  end
end
