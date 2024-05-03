require "rails_helper"

describe Reports::DataPickers::FormDocumentPicker do
  let(:dummy_class) do
    klass = Class.new do
      include Reports::DataPickers::FormDocumentPicker

      def obj; end
    end
  end

  describe "#current_queens_award_holder" do
    let(:subject) { dummy_class.new }

    it "returns nil if no awards were entered" do
      expect(subject).to receive(:obj).and_return(double(previous_wins: nil))
      expect(subject.current_queens_award_holder).to be_nil

      allow(subject).to receive(:obj).and_return(double(previous_wins: []))
      expect(subject.current_queens_award_holder).to be_nil
    end

    it "returns list of awards" do
      year_1, year_2, year_3 = PreviousWin.available_years
      awards = [
        {
          "category" => "innovation",
          "year" => year_1,
          "outcome" => "won",
        },
        {
          "category" => "",
          "year" => year_2,
          "outcome" => "won",
        },
        {
          "category" => "trade",
          "year" => year_3,
          "outcome" => "did_not_win",
        },
      ]

      allow(subject).to receive(:obj).and_return(double(previous_wins: awards))
      expected = "Innovation #{year_1}, #{year_2}"

      expect(subject.current_queens_award_holder).to eq(expected)
    end
  end

  describe "instance methods" do
    let(:custom_class) do
      klass = Class.new do
        include Reports::DataPickers::FormDocumentPicker

        def business_form?; end

        def question_visible?(key); end

        def obj; end

        def trade?; end

        def innovation?; end

        def development?; end

        def mobility?; end
      end
    end
    let(:subject) { custom_class.new }

    context "business_region" do
      it "should return correct doc" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_region" => 1,
                                                                      "nominee_personal_address_region" => 2 }))
        expect(subject.business_region).to eq 1
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.business_region).to eq 2
      end
    end

    context "principal_postcode" do
      it "should return correct value" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_postcode" => "a",
                                                                      "nominee_personal_address_postcode" => "b" }))
        expect(subject.principal_postcode).to eq "A"
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.principal_postcode).to eq "B"
      end
    end
    context "principal_address1" do
      it "should return correct value" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_building" => 1,
                                                                      "nominee_personal_address_building" => 2 }))
        expect(subject.principal_address1).to eq 1
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.principal_address1).to eq 2
      end
    end

    context "principal_address2" do
      it "should return correct value" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_street" => 1,
                                                                      "nominee_personal_address_street" => 2 }))
        expect(subject.principal_address2).to eq 1
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.principal_address2).to eq 2
      end
    end

    context "principal_address3" do
      it "should return correct value" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_city" => 1,
                                                                      "nominee_personal_address_city" => 2 }))
        expect(subject.principal_address3).to eq 1
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.principal_address3).to eq 2
      end
    end

    context "principal_county" do
      it "should return correct value" do
        allow(subject).to receive(:business_form?).and_return(true)
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_county" => "1",
                                                                      "nominee_personal_address_county" => "2" }))
        expect(subject.principal_county).to eq "1"
        allow(subject).to receive(:business_form?).and_return(false)
        expect(subject.principal_county).to eq "2"
      end
    end

    context "sub_category" do
      it "should return nil" do
        allow(subject).to receive(:trade?).and_return(false)
        allow(subject).to receive(:innovation?).and_return(false)
        allow(subject).to receive(:development?).and_return(false)
        allow(subject).to receive(:mobility?).and_return(false)
        object = double(document: {})
        allow(object).to receive(:award_type).and_return(nil)
        allow(subject).to receive(:obj).and_return(object)
        expect(subject.sub_category).to be_nil
      end
    end
  end
end
