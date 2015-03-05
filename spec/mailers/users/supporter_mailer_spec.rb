require "rails_helper"

describe Users::SupporterMailer do
  let(:user) { create(:user) }
  let(:supporter) { create(:supporter) }
  let(:mail) { Users::SupporterMailer.success(supporter.id, user.id) }

  it "renders the headers" do
    expect(mail.subject).to eq("[Queen's Awards for Enterprise] Support Letter Request")
    expect(mail.to).to eq([supporter.email])
    expect(mail.from).to eq(["support@qae.co.uk"])
  end

  it "contains link to the support letter form" do
    expect(mail.body.encoded).to have_link("go to the support letter form page", href: support_letter_url(access_key: supporter.access_key))
  end
end
