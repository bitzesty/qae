require "rails_helper"

RSpec.describe FormAnswer, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    %w(user).each do |field_name|
      it { should validate_presence_of field_name }
    end

    it "award_type" do
      should validate_inclusion_of(:award_type)
        .in_array(FormAnswer::POSSIBLE_AWARDS)
    end
  end

  it "sets account on creating" do
    form_answer = create(:form_answer)
    expect(form_answer.account).to eq(form_answer.user.account)
  end

  context "URN" do
    before do
      FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_#{AwardYear.current.year} RESTART")
      FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_promotion_#{AwardYear.current.year} RESTART")
    end

    let!(:form_answer) do
      create(:form_answer, :trade, :submitted)
    end

    let(:award_year) { AwardYear.current.year.to_s[2..-1] }

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
      expect(form3.urn).to eq("QA0001/#{award_year}EP")
      expect(form4.urn).to eq("QA0004/#{award_year}S")
    end
  end

  describe "#company_or_nominee_from_document" do
    subject { build(:form_answer, kind, document: doc) }
    let(:c_name) { "company name" }
    let(:n_name) { "company name" }

    context "promotion form" do
      let(:doc) { { "organization_name" => " #{c_name} " } }
      let(:kind) { :promotion }

      it "gets the orgzanization name first" do
        expect(subject.company_or_nominee_from_document).to eq(c_name)
      end

      context "organization name blank" do
        let(:doc) { { "nominee_info_first_name" => n_name } }
        it "gets the nominee name" do
          expect(subject.nominee_full_name_from_document).to eq(n_name)
        end
      end
    end

    context "innovation form" do
      let(:doc) { { "company_name" => c_name } }
      let(:kind) { :innovation }
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
