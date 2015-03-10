require 'rails_helper'

RSpec.describe Supporter, type: :model do
  include ActiveJob::TestHelper

  it 'generates access key after creation' do
    expect(create(:supporter).access_key).to be
  end

  describe "Notify supporter" do
    let(:supporter) { create :supporter }
    subject { supporter }

    before do
      clear_enqueued_jobs
      supporter.send(:notify!)
    end

    it 'sends email delevery job to queue upon creation' do
      expect(enqueued_jobs.size).to be_eql(1)
    end
  end
end
