require "rails_helper"

describe AwardYear do
  before { allow(described_class).to receive(:mock_current_year?).and_return(false) }

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

    context "submission beginning period is 28 of Feb 2015" do
      before do
        y = create_award_year(2016)
        d = y.settings.deadlines.submission_start
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

    context "submission begining period is 18 of July 2015, next submission begining 14 of Feb 2016" do
      before do
        y = create_award_year(2016)
        d = y.settings.deadlines.submission_start
        d.update_column(:trigger_at, Date.new(2015, 6, 18))

        y = create_award_year(2017)
        d = y.settings.deadlines.submission_start
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
end

def clean_settings
  AwardYear.all.each(&:destroy)
end

def create_award_year(year)
  AwardYear.where(year: year).first_or_create
rescue ActiveRecord::RecordNotUnique
  retry
end
