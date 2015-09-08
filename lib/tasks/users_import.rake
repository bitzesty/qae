namespace :users_import do

  desc "Imports users from csv"
  task import_from_csv: :environment do
    filepath = ENV["FILEPATH"]
    p "processing: #{filepath}"
    out = UsersImport::Builder.new(filepath).process
    p "processed: #{out[:saved].map(&:email)}"
    if out[:not_saved].present?
      p "not processed: #{out[:not_saved].map(&:email)}"
    end
  end

  desc "Sends welcome mailing"
  task send_welcome: :environment do
    UsersImport::Builder.send_mailing
  end

  desc "Import assessors from CSV"
  task import_assessors: :environment do
    filepath = ENV["FILEPATH"]
    p "processing: #{filepath}"
    out = AssessorsImport::Builder.new(filepath).process
    p "processed: #{out[:saved].map(&:email)}"
    if out[:not_saved].present?
      p "not processed: #{out[:not_saved].map(&:email)}"
    end
  end
end
