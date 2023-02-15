require "rails_helper"

describe Users::SupporterMailer do
  let(:user) { create(:user) }
  let(:supporter) { create(:supporter) }
  let(:mail) { Users::SupporterMailer.success(supporter.id, user.id) }

  before do
    form_answer = supporter.form_answer
    form_answer.document = {
      nominee_info_first_name: "Jon",
      nominee_info_last_name: "Snow",
      user_info_first_name: "Arya",
      user_info_last_name: "Stark",
    }
    form_answer.save!
  end

  it "renders the headers" do
    expect(mail.subject).to eq("[Queen's Awards for Enterprise] Support Letter Request")
    expect(mail.to).to eq([supporter.email])
    expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
  end

  it "contains link to the support letter form and nominee's name" do
    expect(mail.body.raw_source).to include(new_support_letter_url(access_key: supporter.access_key))
    expect(mail.body.encoded).to match(supporter.form_answer.nominator_full_name)
  end
end
