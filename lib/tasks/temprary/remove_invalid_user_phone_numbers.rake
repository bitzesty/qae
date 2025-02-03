namespace :db do
  desc "Remove invalid user phone_numbers"
  task remove_invalid_user_phone_numbers: :environment do
    User.find_each do |user|
      invalid = false

      if user.phone_number && Phonelib.invalid_for_country?(user.phone_number, "GB")
        user.phone_number = nil
        invalid = true
      end

      if user.company_phone_number && Phonelib.invalid_for_country?(user.company_phone_number, "GB")
        user.company_phone_number = nil
        invalid = true
      end

      user.save! if invalid
    end
  end

  desc "Export users with invalid phone numbers"
  task export_user_phone_numbers: :environment do
    CSV.open("user_phone_numbers.csv", "w") do |csv|
      csv << ["Email", "Name", "Number", "Field"]

      User.find_each do |user|
        if user.phone_number && Phonelib.invalid_for_country?(user.phone_number, "GB")
          csv << [
            user.email,
            user.full_name,
            user.phone_number,
            "phone_number",
          ]
        end

        if user.company_phone_number && Phonelib.invalid_for_country?(user.company_phone_number, "GB")
          csv << [
            user.email,
            user.full_name,
            user.company_phone_number,
            "company_phone_number",
          ]
        end
      end
    end
  end
end
