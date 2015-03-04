FactoryGirl.define do
  factory :support_letter_attachment do
    association :user, factory: :user
    association :form_answer, factory: :form_answer
    attachment do
      Rack::Test::UploadedFile.new(
        File.join(
          Rails.root,'spec','support','file_samples','simple_txt_sample.txt'
        )
      )
    end
  end
end
