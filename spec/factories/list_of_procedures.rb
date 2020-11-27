FactoryBot.define do
  factory :list_of_procedures do
    association :form_answer, factory: :form_answer
    attachment_scan_results { "clean" }
    attachment do
      Rack::Test::UploadedFile.new(
        File.join(
          Rails.root,'spec','support','file_samples','list_of_procedures_sample.txt'
        )
      )
    end
  end
end
