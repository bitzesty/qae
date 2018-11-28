require 'rails_helper'

RSpec.describe CustomEmailWorker do
  it 'should perform correctly' do
    allow_any_instance_of(CustomEmailForm).to receive(:send!) {true}
    described_class.new.perform({}.to_json)
  end
end
