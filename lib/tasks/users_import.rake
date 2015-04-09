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
end
