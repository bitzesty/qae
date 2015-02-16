require 'rails_helper'

RSpec.describe FormAnswer, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    %w(user).each do |field_name|
      it { should validate_presence_of field_name }
    end

    it "award_type" do
      should validate_inclusion_of(:award_type).
             in_array(FormAnswer::POSSIBLE_AWARDS)
    end
  end

  it 'sets account on creating' do
    form_answer = FactoryGirl.create(:form_answer)
    expect(form_answer.account).to eq(form_answer.user.account)
  end

  context 'URN' do
    before do
      ["urn_seq_trade","urn_seq_innovation","urn_seq_development","urn_seq_promotion"].each { |seq|
        FormAnswer.connection.execute("ALTER SEQUENCE #{seq} RESTART")
      }

      allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    end
    let!(:form_answer) { FactoryGirl.create(:form_answer, submitted: true) }

    it 'creates form with URN' do
      expect(form_answer.urn).to eq('QA0001/14T')
    end

    it 'increments URN' do
      other_form_answer = FactoryGirl.create(:form_answer, submitted: true)
      expect(other_form_answer.urn).to eq('QA0002/14T')
    end
  end

  context 'supporters' do
    let(:form_answer) { FactoryGirl.create(:form_answer, :promotion) }

    before do
      allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    end

    it 'creates supporters for ep form' do
      form_answer.document = { supporters: [{ email: 'supporter1@example.com' }.to_json, { email: 'supporter2@example.com' }.to_json] }
      form_answer.submitted = true
      expect { form_answer.save!; form_answer.reload }.to change {
        form_answer.supporters.count
      }.by(2)
    end

    context 'with existing supporters' do
      before do
        form_answer.supporters << Supporter.new(email: 'supporter1@example.com')
        form_answer.supporters << Supporter.new(email: 'supporter2@example.com')
      end

      it 'destroys all form_answer supporters if form data is blank' do
        form_answer.submitted = true
        expect { form_answer.save!; form_answer.reload }.to change {
          form_answer.supporters.count
        }.by(-2)
      end

      it 'destroys only one form_answer supporter which is missingfrom the form data' do
        form_answer.submitted = true
        form_answer.document = { supporters: [{ email: 'supporter1@example.com' }.to_json] }
        expect { form_answer.save!; form_answer.reload }.to change {
          form_answer.supporters.count
        }.by(-1)

        expect(form_answer.supporters.first.email).to eq('supporter1@example.com')
      end
    end
  end
end
