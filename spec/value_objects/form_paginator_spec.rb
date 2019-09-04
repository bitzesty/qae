require "rails_helper"

describe FormPaginator do
  let(:user) { create(:admin) }
  let!(:form_answer_1) { create(:form_answer) }
  let!(:form_answer_2) { create(:form_answer) }
  let!(:form_answer_3) { create(:form_answer) }

  before do
    [form_answer_1, form_answer_2, form_answer_3].each_with_index do |fa, i|
      fa.document = { company_name: i.to_s }
      fa.company_or_nominee_name = i.to_s
      fa.save!
    end
  end

  describe "#next_entry" do
    it "returns next entry" do
      paginator = described_class.new(form_answer_2, user)
      expect(paginator.next_entry.id).to eq(form_answer_3.id)
    end

    it "returns nil if current form answer is last" do
      paginator = described_class.new(form_answer_3, user)
      expect(paginator.next_entry).to be_nil
    end
  end

  describe "#prev_entry" do
    it "returns previous entry" do
      paginator = described_class.new(form_answer_2, user)
      expect(paginator.prev_entry.id).to eq(form_answer_1.id)
    end

    it "returns nil if current form answer is first" do
      paginator = described_class.new(form_answer_1, user)
      expect(paginator.prev_entry).to be_nil
    end
  end

  describe "#last?" do
    it "returns true if current form answer is last" do
      paginator = described_class.new(form_answer_3, user)
      expect(paginator.last?).to be_truthy
    end

    it "returns false if current form answer is not last" do
      paginator = described_class.new(form_answer_1, user)
      expect(paginator.last?).to be_falsey
    end
  end

  describe "#first?" do
    it "returns true if current form answer is first" do
      paginator = described_class.new(form_answer_1, user)
      expect(paginator.first?).to be_truthy
    end

    it "returns false if current form answer is not first" do
      paginator = described_class.new(form_answer_2, user)
      expect(paginator.first?).to be_falsey
    end
  end
end
