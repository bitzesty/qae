require "rails_helper"

describe Users::SupporterMailer do
  let(:user) { create(:user) }
  let(:supporter) { create(:supporter) }
  let(:email) { Users::SupporterMailer.success(supporter.id, user.id) }

  it 'contains link to the support letter form' do
    expect(email.subject).to eq("[Queen's Awards for Enterprise] Support Letter Request")
    expect(email.to).to eq([supporter.email])

    url = "http://example.com/support_letter?access_key=#{supporter.access_key}"
    expect(email.body.encoded).to have_link("go to the support letter form page.", href: url)
  end
end
