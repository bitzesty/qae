require "rails_helper"

describe Users::SupporterMailer do
  let(:user) { create(:user) }
  let(:supporter) { create(:supporter) }
  let(:email) { Users::SupporterMailer.success(supporter.id, user.id) }

  before do
    expect(ENV).to receive(:[]).with("mailgun_domain") { 'qae.local' }
  end

  it 'contains link to the support letter form' do
    expect(email.subject).to eq("[Queen's Awards for Enterprise] Support Letter Request")
    expect(email.to).to eq([supporter.email])
    expect(email.body.encoded).to have_link('here', href: "http://qae.local/support_letter?access_key=#{supporter.access_key}")
  end
end
