require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "As Admin I make the case summary edition.", js: true do
  let(:scope) { :admin }
  let(:subject) { create(:admin) }

  it_behaves_like "successful case summary edition"
end
