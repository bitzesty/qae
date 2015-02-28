FactoryGirl.define do
  factory :audit_certificate do
    association :form_answer, factory: :form_answer
    attachment {
      Rack::Test::UploadedFile.new(
        File.join(
          Rails.root,'spec','support','csv_samples','audit_certificate_sample.csv'
        )
      )
    }
  end
end
