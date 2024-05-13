require "csv"

class AssessorsImport::Builder
  attr_reader :csv

  def initialize(filepath)
    file = File.open(filepath).read
    @csv = CSV.parse(file, headers: true)
  end

  def process
    saved = []
    not_saved = []
    @csv.each do |row|
      email = row["email"].downcase if row["email"].present?
      a = Assessor.where(email: email).first_or_initialize
      if a.new_record? && email.present?
        log "saving: #{email}"

        ["first_name", "last_name", "company", "trade_role",	"innovation_role",	"promotion_role",	"development_role"].each do |db_h|
          a.send("#{db_h}=", row[db_h])
        end

        a = assign_password(a)
        a.skip_confirmation!
        if a.save
          saved << a
        else
          log "not saved: #{email}: #{a.errors.inspect}"
          not_saved << a
        end
      else
        log "Email already exists: #{email}"
      end
    end
    log "Imported: #{saved.count}; not_saved: #{not_saved.map(&:email)}"
    { saved: saved, not_saved: not_saved }
  end

  private

  def log(msg)
    puts msg unless Rails.env.test?
  end

  def assign_password(user)
    passw = (0...15).map { (rand(65..90)).chr }.join
    user.password = passw
    user.password_confirmation = passw
    user
  end
end
