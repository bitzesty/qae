require "csv"

class UsersImport::Builder
  attr_reader :csv

  def initialize(filepath)
    file = File.open(filepath).read
    @csv = CSV.parse(file, headers: true)
  end

  def process
    saved = []
    not_saved = []
    @csv.each do |user|
      u = User.where(email: user["RegisteredUserEmail"]).first_or_initialize
      if u.new_record?
        u.imported = true
        map.each do |csv_h, db_h|
          u.send("#{db_h}=", user[csv_h])
        end
        u.role = "regular"
        u = assign_password(u)
        u.agreed_with_privacy_policy = "1"
        u.skip_confirmation!
        if u.save
          u.update_column(:created_at, Date.strptime(user["UserCreationDate"], "%d/%m/%y")) if user["UserCreationDate"].present?
          saved << u
        else
          # probably shouldn't happen
          not_saved << u
        end
      end
    end
    { saved: saved, not_saved: not_saved }
  end

  def self.send_mailing
    User.where(imported: true).each do |user|
      raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
      user.reset_password_token = hashed_token
      user.reset_password_sent_at = Time.now.utc
      if user.save
        Users::ImportMailer.notify_about_release(user.id, raw_token).deliver_later!
      end
    end
  end

  private

  def map
    {
      "RegisteredUserTitle" => :job_title,
      "RegisteredUserCompany" => :company_name,
      "RegisteredUserSurname" => :last_name,
      "RegisteredUserFirstname" => :first_name,
      "RegisteredUserAddressLine1" => :address_line1,
      "RegisteredUserAddressLine2" => :address_line2,
      "RegisteredUserAddressLine3" => :address_line3,
      "RegisteredUserPostcode" => :postcode,
      "RegisteredUserTelephone1" => :phone_number,
      "RegisteredUserTelephone2" => :phone_number2,
      "RegisteredUserMobile" => :mobile_number
    }
  end

  def assign_password(user)
    passw = (0...15).map { (65 + rand(26)).chr }.join
    user.password = passw
    user.password_confirmation = passw
    user
  end
end
