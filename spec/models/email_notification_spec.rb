require "rails_helper"
require "models/shared/formatted_time_for_examples"

RSpec.describe EmailNotification do
  describe "#trigger_at" do
    include_examples "date_time_for", :trigger_at
  end
end
