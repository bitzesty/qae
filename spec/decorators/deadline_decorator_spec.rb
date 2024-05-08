require "rails_helper"

describe DeadlineDecorator do
  let(:deadline) { Deadline.new }
  let(:subject) { DeadlineDecorator.decorate(deadline) }

  describe "#message" do
    Deadline::AVAILABLE_DEADLINES.each do |kind|
      context "#{kind}" do
        it "returns the expected message based on translation" do
          deadline.kind = kind
          expect(subject.message).to eq(I18n.t("deadline_messages.#{kind}"))
        end
      end
    end
  end

  describe "#help_message" do
    Deadline::AVAILABLE_DEADLINES.each do |kind|
      context "#{kind}" do
        it "returns the expected message based on translation" do
          deadline.kind = kind
          expect(subject.help_message).to eq(I18n.t("deadline_help_messages.#{kind}"))
        end
      end
    end
  end
end
