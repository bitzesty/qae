require 'rails_helper'

describe Eligibility do

  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:form_answer) }
  it { is_expected.to validate(:current_step_validation) }

  describe '#class_methods' do
    
  end
end
