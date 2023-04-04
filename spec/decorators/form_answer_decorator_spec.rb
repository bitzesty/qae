require "rails_helper"

describe FormAnswerDecorator do
  DOCUMENT_FIELDS = {
    nominee_organisation: "organization_address_name",
    nominee_position: "nominee_position",
    nominee_building: "nominee_personal_address_building",
    nominee_street: "nominee_personal_address_street",
    nominee_city: "nominee_personal_address_city",
    nominee_county: "nominee_personal_address_county",
    nominee_postcode: "nominee_personal_address_postcode",
    nominee_telephone: "nominee_phone",
    nominee_email: "nominee_email",
    nominee_region: "nominee_personal_address_region",
    nominator_building: "personal_address_building",
    nominator_street: "personal_address_street",
    nominator_city: "personal_address_city",
    nominator_county: "personal_address_county",
    nominator_postcode: "personal_address_postcode",
    nominator_telephone: "personal_phone",
    nominator_email: "personal_email",
    registration_number: "registration_number",
    website_url: "website_url",
    head_of_business_title: "head_of_business_title",
    head_of_business_honours: "head_of_business_honours",
    head_of_business_job_title: "head_of_business_job_title",
    head_of_business_email: "head_of_business_email",
    applying_for: "applying_for",
    parent_company: "parent_company",
    parent_company_country: "parent_company_country",
    parent_ultimate_control: "parent_ultimate_control",
    ultimate_control_company: "ultimate_control_company",
    ultimate_control_company_country: "ultimate_control_company_country",
    innovation_desc_short: "innovation_desc_short",
    development_desc_short: "development_desc_short",
    development_management_approach_briefly: "development_management_approach_briefly",
    mobility_desc_short: "mobility_desc_short",
    organisation_type: "organisation_type"
  }

  let(:user) { build_stubbed(:user, first_name: "John", last_name: "Doe") }

  describe "#average_growth_for" do
    subject { described_class.new form_answer }
    let!(:form_answer) { build(:form_answer, document: { sic_code: sic_code.code }) }
    let(:year) { 1 }

    context "sic code present" do
      let(:sic_code) { SICCode.first }
      it "returns average growth for specific year" do
        expect(subject.average_growth_for(year)).to eq(sic_code.by_year(year))
      end
    end

    context "sic code not present" do
      let(:sic_code) { double(code: nil) }
      it "returns nil" do
        expect(subject.average_growth_for(year)).to be_nil
      end
    end
  end

  describe "#last_state_updated_by" do
    it "Returns the person and time of who made the last transition" do

      Timecop.freeze(DateTime.new(Date.current.year, 2, 6, 8, 30)) do
        form_answer = create(:form_answer).decorate
        form_answer.state_machine.submit(form_answer.user)
        expect(form_answer.last_state_updated_by).to eq("Updated by John Doe -  6 Feb #{Date.current.year} at 8:30am")
      end
    end
  end

  describe "#feedback_updated_by" do
    it "Returns the person and time of who made the feedback" do
      Timecop.freeze(DateTime.new(Date.current.year, 2, 6, 8, 30)) do
        form_answer = create(:feedback, authorable: user).form_answer.decorate
        expect(form_answer.feedback_updated_by).to eq("Updated by: John Doe -  6 Feb #{Date.current.year} at 8:30am")
      end
    end
  end

  describe "#press_summary" do
    it "Returns the person and time of who made the last transition" do
      Timecop.freeze(DateTime.new(Date.current.year, 2, 6, 8, 30)) do
        form_answer = create(:press_summary, authorable: user).form_answer.decorate
        expect(form_answer.press_summary_updated_by).to eq("Updated by John Doe -  6 Feb #{Date.current.year} at 8:30am")
      end
    end
  end

  describe "#dashboard_status" do
    it "returns fill progress when application is not submitted" do
     form_answer = create(:form_answer, :trade, state: "application_in_progress", document: { sic_code:  SICCode.first.code })
      expect(described_class.new(form_answer).dashboard_status).to eq("Application in progress...9%")
    end

    it "warns that assessors are not assigned if assessment is in progress and assessors are not assigned yet for admin section" do
      form_answer = create(:form_answer, :trade, :submitted, state: "assessment_in_progress")
      expect(described_class.new(form_answer).dashboard_status("admin")).to eq("Assessors are not assigned")
    end

    it "returns assessors' names if assessment is in progress and assessors are assigned for admin section" do
      assessor1 = create(:assessor, :regular_for_all, first_name: "Jon", last_name: "Snow")
      assessor2 = create(:assessor, :regular_for_all, first_name: "Ramsay", last_name: "Snow")

      form_answer = create(:form_answer, :trade, :submitted, state: "assessment_in_progress")

      primary = form_answer.assessor_assignments.primary
      secondary = form_answer.assessor_assignments.secondary

      primary.assessor = assessor1
      secondary.assessor = assessor2
      primary.save
      secondary.save

      expect(described_class.new(form_answer).dashboard_status("admin")).to eq("Jon Snow, Ramsay Snow")
    end

    it "warns that assessors are not assigned if assessment is in progress and assessors are not assigned yet for assessor section" do
      form_answer = create(:form_answer, :trade, :submitted, state: "assessment_in_progress")
      expect(described_class.new(form_answer).dashboard_status).to eq("Assessment in progress")
    end

    it "returns assessors' names if assessment is in progress and assessors are assigned for assessor section" do
      assessor1 = create(:assessor, :regular_for_all, first_name: "Jon", last_name: "Snow")
      assessor2 = create(:assessor, :regular_for_all, first_name: "Ramsay", last_name: "Snow")

      form_answer = create(:form_answer, :trade, :submitted, state: "assessment_in_progress")

      primary = form_answer.assessor_assignments.primary
      secondary = form_answer.assessor_assignments.secondary

      primary.assessor = assessor1
      secondary.assessor = assessor2
      primary.save
      secondary.save

      expect(described_class.new(form_answer).dashboard_status).to eq("Assessment in progress")
    end

    it "returns application state after assessment is ended" do
      form_answer = create(:form_answer, :trade, :submitted, state: "not_recommended")
      expect(described_class.new(form_answer).dashboard_status).to eq("Not recommended")

      form_answer.update_column(:state, "not_awarded")
      expect(described_class.new(form_answer).dashboard_status).to eq("Not awarded")

      form_answer.update_column(:state, "disqualified")
      expect(described_class.new(form_answer).dashboard_status).to eq("Disqualified - no additional financials")
    end
  end

  describe "#application_background" do
    it "returns the trade_goods_briefly value if is type trade" do
      document = {trade_goods_briefly: "International Trade"}
      form = build(:form_answer, :trade, document: document)

      decorated_app = described_class.new(form)

      expect(decorated_app.application_background).to eq("International Trade")
    end

    it "returns the trade_goods_briefly value if is type innovation" do
      document = {innovation_desc_short: "Innovation"}
      form = build(:form_answer, :innovation, document: document)

      decorated_app = described_class.new(form)

      expect(decorated_app.application_background).to eq("Innovation")
    end

    it "returns the trade_goods_briefly value if is type development" do
      document = {development_management_approach_briefly: "Development"}
      form = build(:form_answer, :development, document: document)

      decorated_app = described_class.new(form)

      expect(decorated_app.application_background).to eq("Development")
    end

    it "returns the trade_goods_briefly value if is type mobility" do
      document = {mobility_desc_short: "Mobility"}
      form = build(:form_answer, :mobility, document: document)

      decorated_app = described_class.new(form)

      expect(decorated_app.application_background).to eq("Mobility")
    end
  end

  DOCUMENT_FIELDS.keys.each do |field|
    describe "##{field}" do
      it "returns the document field with key #{DOCUMENT_FIELDS[field]}" do
        document = {DOCUMENT_FIELDS[field] => 'An expected value'}
        form = build(:form_answer, :development, document: document)

        decorated_app = described_class.new(form)
        expect(decorated_app.send(field)).to eq(document[DOCUMENT_FIELDS[field]])
      end
    end
  end

  describe "show_this_entry_relates_to_question?" do
    let(:form_answer) { build(:form_answer) }

    context "for innovation and trade" do
      it "returns true for 2020" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2020))

        form_answer.award_type = "trade"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)

        form_answer.award_type = "innovation"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)
      end

      it "returns true for 2019" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2019))

        form_answer.award_type = "trade"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)

        form_answer.award_type = "innovation"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)
      end
    end

    context "for development and mobility" do
      it "returns false for 2020" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2020))

        form_answer.award_type = "development"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(false)

        form_answer.award_type = "mobility"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(false)
      end

      it "returns true for 2019" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2019))

        form_answer.award_type = "development"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)

        form_answer.award_type = "development"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(true)
      end
    end

    context "for promotion" do
      it "returns false for 2020" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2020))

        form_answer.award_type = "promotion"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(false)
      end

      it "returns false for 2019" do
        allow(form_answer).to receive(:award_year).and_return(double(year: 2019))

        form_answer.award_type = "promotion"
        decorator = described_class.new form_answer
        expect(decorator.show_this_entry_relates_to_question?).to eq(false)
      end
    end
  end
end
