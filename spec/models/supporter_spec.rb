require 'rails_helper'

RSpec.describe Supporter, :type => :model do
  it 'generates access key after creation' do
    expect(create(:supporter).access_key).to be
  end
end
