require 'rails_helper'

RSpec.describe Supporter, :type => :model do
  it 'generates access key after creation' do
    expect(create(:supporter).access_key).to be
  end

  it 'sends email delevery job to queue upon creation' do
    mailer = double(success: true)
    expect(Users::SupporterMailer).to receive(:delay) { mailer }
    create(:supporter)
  end
end
