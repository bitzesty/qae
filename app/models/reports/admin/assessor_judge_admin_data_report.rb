class Reports::Admin::AssessorJudgeAdminDataReport
  include Reports::CsvHelper

  MAPPING = [
    {
      label: "ID",
      method: :id,
    },
    {
      label: "First name",
      method: :first_name,
    },
    {
      label: "Last name",
      method: :last_name,
    },
    {
      label: "Company",
      method: :company,
    },
    {
      label: "Email",
      method: :email,
    },
    {
      label: "Telephone",
      method: :telephone_number,
    },
    {
      label: "User type",
      method: :user_type,
    },
    {
      label: "Status",
      method: :status,
    },
    {
      label: "User creation date",
      method: :created_at,
    },
    {
      label: "Last sign in date",
      method: :last_sign_in_at,
    },
    {
      label: "Awards assigned",
      method: :awards_assigned,
    },
  ]

  def as_csv
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << headers

      Admin.find_each do |user|
        u = Reports::User.new(user)

        csv << mapping.map do |m|
          sanitize_string(
            u.call_method(m[:method]),
          )
        end
      end

      Assessor.find_each do |user|
        u = Reports::User.new(user)

        csv << mapping.map do |m|
          sanitize_string(
            u.call_method(m[:method]),
          )
        end
      end

      Judge.active.find_each do |user|
        u = Reports::User.new(user)

        csv << mapping.map do |m|
          sanitize_string(
            u.call_method(m[:method]),
          )
        end
      end
    end
  end

  def csv_filename
    "assessors_judges_admins_data.csv"
  end

  private

  def mapping
    MAPPING
  end
end
