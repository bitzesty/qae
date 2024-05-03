require "rails_helper"

describe AwardYear do
  before do
    allow(described_class).to receive(:mock_current_year?).and_return(false)
  end

  describe ".current" do
    context "default submission beginning (21 of April 2015)" do
      context "20 of April 2015" do
        it "is awarding year 2015" do
          Timecop.freeze(Date.new(2015, 4, 20)) do
            clean_settings
            expect(described_class.current.year).to eq(2015)
          end
        end
      end

      context "22 of April 2015" do
        it "is awarding year 2016" do
          Timecop.freeze(Date.new(2015, 4, 22)) do
            clean_settings
            expect(described_class.current.year).to eq(2016)
          end
        end
      end

      context "1 of January 2016" do
        it "is awarding year 2016" do
          Timecop.freeze(Date.new(2016, 1, 1)) do
            clean_settings
            expect(described_class.current.year).to eq(2016)
          end
        end
      end

      context "22 of April 2016" do
        it "is awarding year 2017" do
          Timecop.freeze(Date.new(2016, 4, 22)) do
            clean_settings
            expect(described_class.current.year).to eq(2017)
          end
        end
      end
    end

    context "current year beginning period is 28 of Feb 2015" do
      before do
        y = create_award_year(2016)
        d = y.settings.deadlines.award_year_switch
        d.update_column(:trigger_at, Date.new(2015, 2, 28))
      end

      context "27 of Feb 2015" do
        it "is awarding year 2015" do
          Timecop.freeze(Date.new(2015, 2, 27)) do
            expect(described_class.current.year).to eq(2015)
          end
        end
      end

      context "1 of March 2015" do
        it "is awarding year 2016" do
          Timecop.freeze(Date.new(2015, 3, 1)) do
            expect(described_class.current.year).to eq(2016)
          end
        end
      end

      context "1 of January 2016" do
        it "is awarding year 2016" do
          Timecop.freeze(Date.new(2016, 1, 1)) do
            expect(described_class.current.year).to eq(2016)
          end
        end
      end

      context "22 of April 2016" do
        it "is awarding year 2017 (takes 21.04 as default)" do
          Timecop.freeze(Date.new(2016, 4, 22)) do
            expect(described_class.current.year).to eq(2017)
          end
        end
      end
    end

    context "award year begining is 18 of July 2015, next award year begining 14 of Feb 2016" do
      before do
        y = create_award_year(2016)
        d = y.settings.deadlines.award_year_switch
        d.update_column(:trigger_at, Date.new(2015, 6, 18))

        y = create_award_year(2017)
        d = y.settings.deadlines.award_year_switch
        d.update_column(:trigger_at, Date.new(2016, 2, 14))
      end

      context "2015" do
        context "17 of July" do
          it "is awarding year 2015" do
            Timecop.freeze(Date.new(2015, 6, 17)) do
              expect(described_class.current.year).to eq(2015)
            end
          end
        end

        context "18 of July" do
          it "is awarding year 2016" do
            Timecop.freeze(DateTime.new(2015, 6, 18, 0, 0)) do
              expect(described_class.current.year).to eq(2016)
            end
          end
        end

        context "19 of July" do
          it "is awarding year 2016" do
            Timecop.freeze(DateTime.new(2015, 6, 19, 0, 0)) do
              expect(described_class.current.year).to eq(2016)
            end
          end
        end
      end

      context "2016" do
        context "1 of Feb 2016" do
          it "is awarding year 2016" do
            Timecop.freeze(DateTime.new(2016, 2, 1)) do
              expect(described_class.current.year).to eq(2016)
            end
          end
        end

        context "14 of Feb 2016" do
          it "is awarding year 2017" do
            Timecop.freeze(DateTime.new(2016, 2, 14, 0, 0)) do
              expect(described_class.current.year).to eq(2017)
            end
          end
        end
      end
    end
  end

  describe ".start_trading_since" do
    it "returns 03/09/20XX date for award years before 2019" do
      Timecop.freeze(Date.new(2016, 5, 22)) do
        clean_settings
        expect(described_class.start_trading_since(1)).to eq("03/09/2015")
      end
    end

    it "returns 17/09/20XX date for award years after 2019" do
      Timecop.freeze(Date.new(2018, 5, 22)) do
        clean_settings
        expect(described_class.start_trading_since(1)).to eq("17/09/2017")
      end
    end

    it "returns actual submission deadline date if it's set up after 2019" do
      Timecop.freeze(Date.new(2018, 5, 22)) do
        clean_settings
        deadline = Settings.current_submission_deadline
        deadline.update_column(:trigger_at, Date.new(2019, 10, 22))
        expect(described_class.start_trading_since(1)).to eq("22/10/2017")
      end
    end
  end

  describe ".award_holder_range" do
    it "should return range" do
      range = "#{AwardYear.current.year - 5}-#{AwardYear.current.year - 1}"
      expect(AwardYear.award_holder_range).to eq range
    end
  end

  describe "instance methods" do
    let(:award_year) { build(:award_year) }
    context "form_data_generation_can_be_started?" do
      it "should return correct value" do
        allow(Settings).to receive(:after_current_submission_deadline?) { true }
        allow_any_instance_of(AwardYear).to receive(:form_data_hard_copies_state) { nil }
        expect(award_year.form_data_generation_can_be_started?).to be_truthy

        allow_any_instance_of(AwardYear).to receive(:form_data_hard_copies_state) { "not_nil" }
        expect(award_year.form_data_generation_can_be_started?).to be_falsey
      end
    end

    context "case_summary_generation_can_be_started?" do
      it "should return correct value" do
        allow(Settings).to receive(:winners_stage?) { true }
        allow_any_instance_of(AwardYear).to receive(:case_summary_hard_copies_state) { nil }
        expect(award_year.case_summary_generation_can_be_started?).to be_truthy

        allow_any_instance_of(AwardYear).to receive(:case_summary_hard_copies_state) { "not_nil" }
        expect(award_year.case_summary_generation_can_be_started?).to be_falsey
      end
    end

    context "feedback_generation_can_be_started?" do
      it "should return correct value" do
        allow(Settings).to receive(:unsuccessful_stage?) { true }
        allow_any_instance_of(AwardYear).to receive(:feedback_hard_copies_state) { nil }
        expect(award_year.feedback_generation_can_be_started?).to be_truthy

        allow_any_instance_of(AwardYear).to receive(:feedback_hard_copies_state) { "not_nil" }
        expect(award_year.feedback_generation_can_be_started?).to be_falsey
      end
    end

    context "aggregated_case_summary_generation_can_be_started?" do
      it "should return correct value" do
        allow(Settings).to receive(:winners_stage?) { true }
        allow_any_instance_of(AwardYear).to receive(:aggregated_case_summary_hard_copy_state) { nil }
        expect(award_year.aggregated_case_summary_generation_can_be_started?).to be_truthy

        allow_any_instance_of(AwardYear).to receive(:aggregated_case_summary_hard_copy_state) { "not_nil" }
        expect(award_year.aggregated_case_summary_generation_can_be_started?).to be_falsey
      end
    end

    context "aggregated_feedback_generation_can_be_started?" do
      it "should return correct value" do
        allow(Settings).to receive(:unsuccessful_stage?) { true }
        allow_any_instance_of(AwardYear).to receive(:aggregated_feedback_hard_copy_state) { nil }
        expect(award_year.aggregated_feedback_generation_can_be_started?).to be_truthy

        allow_any_instance_of(AwardYear).to receive(:aggregated_feedback_hard_copy_state) { "not_nil" }
        expect(award_year.aggregated_feedback_generation_can_be_started?).to be_falsey
      end
    end

    context "check_aggregated_hard_copy_pdf_generation_status!" do
      it "should return false" do
        expect(award_year.check_aggregated_hard_copy_pdf_generation_status!("feedback")).to be_falsey
      end
    end
  end
end

def clean_settings
  AwardYear.all.each(&:destroy)
end

def create_award_year(year)
  AwardYear.where(year:).first_or_create
rescue ActiveRecord::RecordNotUnique
  retry
end
