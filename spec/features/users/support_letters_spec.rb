require "rails_helper"

describe "Submission of SupportLetter", %(
As a Supporter
I want to be able to fill and submit support letter
So that I can support my nominator
) do
  let!(:user) { create(:user) }
  let!(:form_answer) { create(:form_answer, :promotion, user:) }
  let!(:supporter) do
    create :supporter, form_answer:,
                       user:
  end
  let(:access_key) { supporter.access_key }
  let(:support_letter) do
    SupportLetter.last
  end

  describe "Show" do
    it "should reject supporter with wrong access key" do
      visit new_support_letter_url(access_key: "foobar")
      expect(page.status_code).to eq(404)
    end

    it "should allow to access to letter with proper access_key" do
      visit new_support_letter_url(access_key: supporter.access_key)

      expect(page.status_code).to eq(200)
      expect_to_see supporter.form_answer.nominee_full_name
    end

    describe "Already submitted letter" do
      let!(:support_letter) do
        create :support_letter, form_answer:,
                                user:,
                                supporter:
      end

      before do
        support_letter
        visit new_support_letter_url(access_key: supporter.access_key)
      end

      it "should not allow to update already submitted letter" do
        expect_to_see "Support Letter has been submitted already!"
        expect_to_see support_letter.body
      end
    end
  end

  describe "Submission" do
    before do
      visit new_support_letter_url(access_key: supporter.access_key)
    end

    describe "validations" do
      it "should not allow to submit empty letter" do
        # Clear prefilled supporter data
        fill_in "First name", with: ""
        fill_in "Surname", with: ""
        fill_in "support_letter_relationship_to_nominee", with: ""

        expect do
          click_on "Submit"
        end.not_to(change do
          SupportLetter.count
        end)

        expect_to_see "First name is empty - it is a required field and must be filled in"
      end
    end

    it "should allow to submit proper letter" do
      fill_in "First name", with: "Test"
      fill_in "Surname", with: "Test"
      fill_in "support_letter_relationship_to_nominee", with: "Friend"
      fill_in "support_letter_body", with: "Letter"

      expect do
        click_on "Submit"
      end.to change {
        SupportLetter.count
      }.by(1)

      expect_to_see "Support letter was successfully created"

      expect(support_letter.supporter_id).to be_eql supporter.id
      expect(support_letter.form_answer_id).to be_eql form_answer.id
      expect(support_letter.user_id).to be_eql user.id
    end
  end
end
