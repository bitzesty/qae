require "rails_helper"

describe FormAnswerUserSubmissionService do
  subject { described_class.new(form_answer) }

  let(:document) do
    {
      "queen_award_holder_details" => "[\"{\\\"category\\\":\\\"innovation\\\",\\\"year\\\":\\\"2012\\\"}\", \"{\\\"category\\\":\\\"innovation\\\",\\\"year\\\":\\\"2011\\\"}\", \"{\\\"category\\\":\\\"international_trade\\\",\\\"year\\\":\\\"2015\\\"}\", \"{\\\"category\\\":\\\"sustainable_development\\\",\\\"year\\\":\\\"2014\\\"}\", \"{\\\"category\\\":\\\"sustainable_development\\\",\\\"year\\\":\\\"\\\"}\", \"{\\\"category\\\":\\\"\\\",\\\"year\\\":\\\"\\\"}\"]"
    } # prob. would be replaced with hash after HSTORE -> json migration
  end

  let(:form_answer) do
    create(:form_answer, document: document)
  end

  it "assigns the previous wins from the form data/does not add the blank data" do
    expect { subject.perform }.to change { form_answer.reload.previous_wins.map(&:category) }
      .from([]).to([
        "innovation",
        "innovation",
        "international_trade",
        "sustainable_development",
        "sustainable_development"
      ])
  end
end
