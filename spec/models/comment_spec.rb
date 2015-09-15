require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject{ build(:comment)}

  it 'has valid factory' do
    expect(subject).to be_valid
  end
end
