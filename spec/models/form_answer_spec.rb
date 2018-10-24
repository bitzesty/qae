require "rails_helper"

RSpec.describe FormAnswer, type: :model do
  let(:form_answer) {build(:form_answer)}
  describe "associations" do
    it {should belong_to(:user)}
  end

  describe 'class methods & scopes ' do
    it ".hard_copy_generated should filter correctly" do
      target = FormAnswer.submitted.where("feedback_hard_copy_generated" => true).to_sql
      expect(target).to eq FormAnswer.hard_copy_generated('feedback').to_sql
    end
  end

  describe "#unsuccessful?" do
    it 'should return correct class' do
      allow_any_instance_of(FormAnswer).to receive(:not_recommended?) {true}
      expect(form_answer.unsuccessful?).to be_truthy
    end
  end

  describe "#eligibility_class" do
    it 'should return correct class' do
      expect(FormAnswer.new(award_type: 'trade').eligibility_class).to eq Eligibility::Trade
    end
  end

  describe "#head_of_business" do
    it 'should return correct result' do
      form_answer = FormAnswer.new(document: { "head_of_business_first_name" => "foo", "head_of_business_last_name" => "bar" })
      expect(form_answer.head_of_business).to eq "foo bar"
    end
  end

  describe "#performance_years" do
    it 'should return correct result' do
      form_answer = FormAnswer.new(award_type: "innovation", document: { "innovation_performance_years" => 2018 })
      expect(form_answer.performance_years).to eq 2018
    end
  end

  describe "#whodunnit" do
    it 'should return correct result' do
      user = build(:user)
      allow(PaperTrail).to receive(:whodunnit) {user}
      expect(form_answer.whodunnit).to eq user
    end
  end

  describe "#shortlisted?" do
    it 'should return correct result' do
      form_answer.state = 'reserved'
      expect(form_answer.shortlisted?).to be_truthy
    end
  end

  describe "#unsuccessful_app?" do
    it 'should return correct result' do
      allow_any_instance_of(FormAnswer).to receive(:awarded?) {false}
      allow_any_instance_of(FormAnswer).to receive(:withdrawn?) {false}
      expect(form_answer.unsuccessful_app?).to be_truthy
    end
  end

  describe "#previous_wins" do
    it 'should return correct result' do
      form_answer.document = { "applied_for_queen_awards_details" => [{ "outcome" => "won", "foo" => "bar" }, { "outcome" => "failed", "lorem" => "ipsum" }] }
      expect(form_answer.previous_wins).to eq [{ "outcome" => "won", "foo" => "bar" }]

      form_answer.document = { "queen_award_holder_details" => "aa" }
      expect(form_answer.previous_wins).to eq "aa"

      form_answer.document = {}
      expect(form_answer.previous_wins).to eq []
    end
  end

  describe "pdf generation" do
    it '#generate_pdf_version! triggers correctly' do
      expect(HardCopyGenerators::FormDataGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_pdf_version!
    end

    it '#generate_pdf_version_from_latest_doc! triggers correctly' do
      expect(HardCopyGenerators::FormDataGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_pdf_version_from_latest_doc!
    end

    it '#generate_case_summary_hard_copy_pdf! triggers correctly' do
      expect(HardCopyGenerators::CaseSummaryGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_case_summary_hard_copy_pdf!
    end

    it '#generate_feedback_hard_copy_pdf! triggers correctly' do
      expect(HardCopyGenerators::FeedbackGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_feedback_hard_copy_pdf!
    end

  end

  describe "validations" do
    %w(user).each do |field_name|
      it {should validate_presence_of field_name}
    end

    it "award_type" do
      should validate_inclusion_of(:award_type)
                 .in_array(FormAnswer::POSSIBLE_AWARDS)
    end

    it "validates A5 date" do
      form_answer = create(:form_answer, :trade)
      form_answer.submitted_at = Time.zone.now

      form_answer.document = form_answer.document.merge(started_trading_day: "2",
                                                        started_trading_month: 12,
                                                        started_trading_year: Date.current.year - 2,
                                                        trade_commercial_success: "6 plus")
      expect(form_answer).to be_invalid

      form_answer.document = form_answer.document.merge(started_trading_day: "2",
                                                        started_trading_month: 12,
                                                        started_trading_year: Date.current.year - 7,
                                                        trade_commercial_success: "6 plus")
      expect(form_answer).to be_valid
    end
  end

  it "sets account on creating" do
    form_answer = create(:form_answer)
    expect(form_answer.account).to eq(form_answer.user.account)
  end

  context "URN" do
    before do
      FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_#{AwardYear.current.year} RESTART")
      FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_promotion_2018 RESTART")
    end

    let!(:form_answer) do
      create(:form_answer, :trade, :submitted)
    end

    let(:award_year) {AwardYear.current.year.to_s[2..-1]}

    it "creates form with URN" do
      expect(form_answer.urn).to eq("QA0001/#{award_year}T")
    end

    it "increments URN" do
      other_form_answer = create(:form_answer, :trade, :submitted)
      expect(other_form_answer.urn).to eq("QA0002/#{award_year}T")
    end

    it "increments global counter, shared for all categories" do
      form1 = create(:form_answer, :trade, submitted_at: Time.current)
      form2 = create(:form_answer, :innovation, submitted_at: Time.current)
      form3 = create(:form_answer, :promotion, submitted_at: Time.current)
      form4 = create(:form_answer, :development, submitted_at: Time.current)

      expect(form1.urn).to eq("QA0002/#{award_year}T")
      expect(form2.urn).to eq("QA0003/#{award_year}I")
      expect(form3.urn).to eq("QA0001/18EP")
      expect(form4.urn).to eq("QA0004/#{award_year}S")
    end
  end

  describe "#company_or_nominee_from_document" do
    subject {build(:form_answer, kind, document: doc)}
    let(:c_name) {"company name"}
    let(:n_name) {"company name"}

    context "promotion form" do
      let(:doc) {{ "organization_name" => " #{c_name} " }}
      let(:kind) {:promotion}

      it "gets the orgzanization name first" do
        expect(subject.company_or_nominee_from_document).to eq(c_name)
      end

      context "organization name blank" do
        let(:doc) {{ "nominee_info_first_name" => n_name }}
        it "gets the nominee name" do
          expect(subject.nominee_full_name_from_document).to eq(n_name)
        end
      end
    end

    context "innovation form" do
      let(:doc) {{ "company_name" => c_name }}
      let(:kind) {:innovation}
      it "gets the company name" do
        expect(subject.company_or_nominee_from_document).to eq(c_name)
      end
    end
  end

  describe "#fill_progress_in_percents" do
    it "returns fill progress as formatted string" do
      form_answer = build(:form_answer, fill_progress: 0.11)
      expect(form_answer.fill_progress_in_percents).to eq("11%")
    end
  end

  describe "#fill_progress" do
    context "100% completed" do
      it "populates correct fill progress for trade form on save" do
        form_answer = create(:form_answer, :trade)
        expect(form_answer.fill_progress).to eq(1)
      end

      it "populates correct fill progress for development form on save" do
        form_answer = create(:form_answer, :development)
        expect(form_answer.fill_progress).to eq(1)
      end

      it "populates correct fill progress for innovation form on save" do
        form_answer = create(:form_answer, :innovation)
        expect(form_answer.fill_progress).to eq(1)
      end
    end

    context "not completed" do
      it "populates correct fill progress for trade form on save" do
        form_answer = create(:form_answer, :trade)
        form_answer.document = form_answer.document.merge(principal_business: nil)
        form_answer.save!

        expect(form_answer.fill_progress.round(2)).to eq(0.98)
      end

      it "populates correct fill progress for development form on save" do
        form_answer = create(:form_answer, :development)
        form_answer.document = form_answer.document.merge(principal_business: nil)
        form_answer.save!

        expect(form_answer.fill_progress.round(2)).to eq(0.98)
      end

      it "populates correct fill progress for innovation form on save" do
        form_answer = create(:form_answer, :innovation)
        form_answer.document = form_answer.document.merge(principal_business: nil)
        form_answer.save!

        expect(form_answer.fill_progress.round(2)).to eq(0.98)
      end
    end
  end

  describe "state helpers" do
    it "exposes the state as ? method" do
      expect(build(:form_answer, state: "not_awarded")).to be_not_awarded
      expect(build(:form_answer, state: "reserved")).to be_reserved
      expect(build(:form_answer, state: "recommended")).to be_recommended
    end
  end

  describe "unsuccessful_applications" do
    it "excludes awarded form_answers" do
      form_answer = create(:form_answer, :promotion, :awarded)
      expect(FormAnswer.unsuccessful_applications).not_to include(form_answer)
    end

    it "excludes withdrawn form_answers" do
      form_answer = create(:form_answer, :promotion, :withdrawn)
      expect(FormAnswer.unsuccessful_applications).not_to include(form_answer)
    end

    it "includes all other form_answers" do
      not_recommended = create(:form_answer, :promotion, :not_recommended)
      not_awarded = create(:form_answer, :promotion, :not_awarded)
      reserved = create(:form_answer, :promotion, :reserved)
      expect(FormAnswer.unsuccessful_applications).to include(not_recommended)
      expect(FormAnswer.unsuccessful_applications).to include(not_awarded)
      expect(FormAnswer.unsuccessful_applications).to include(reserved)
    end
  end
end
