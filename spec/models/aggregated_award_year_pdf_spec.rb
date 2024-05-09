require "rails_helper"

describe AggregatedAwardYearPdf do
  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_presence_of(:award_category) }
  it { is_expected.to validate_presence_of(:type_of_report) }
  it { is_expected.to validate_presence_of(:award_year_id) }
  it { is_expected.to belong_to(:award_year).optional }
end
