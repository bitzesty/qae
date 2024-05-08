FactoryBot.define do
  factory :vat_returns_file do
    association :form_answer, factory: :form_answer
    association :shortlisted_documents_wrapper, factory: :shortlisted_documents_wrapper

    attachment do
      Rack::Test::UploadedFile.new(
        File.join(
          Rails.root,"spec","support","file_samples","audit_certificate_sample.pdf"
        )
      )
    end

    attachment_scan_results { "clean" }
  end
end
