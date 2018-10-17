require "rails_helper"

RSpec.describe Assessor, type: :model do
  it { is_expected.to belong_to(:form_answer) }
  it { is_expected.to validate_presence_of(:form_answer) }
  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_presence_of(:original_filename) }
end
