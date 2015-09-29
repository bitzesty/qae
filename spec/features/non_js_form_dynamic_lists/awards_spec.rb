require 'rails_helper'
include Warden::Test::Helpers

describe "Non JS | Dynamic Lists | Awards", %q{
As a User
I want to be able to add Awards to Form application
So that I can fill form completelly even if Javascript is turned off
} do

  include_context "non js form base"

  describe "Award interactions" do
    describe "Holder Awards" do
      let(:question_namespace) { "awards" }
      let(:conditional_answer) { { award_holder: "yes" } }

      let(:award_1) do
        (Date.today - 2.years).year.to_s
      end

      let(:award_2) do
        (Date.today - 1.years).year.to_s
      end

      let(:awards) do
        [
          {title: "Award1", details: "Details1", year: award_1},
          {title: "Award2", details: "Details2", year: award_2}
        ]
      end

      let(:new_award_year) { AwardYear.current.year.to_s }

      include_context "non js form ep form awards"
    end

    describe "Nomination Awards" do
      let(:question_namespace) { "nomination_awards" }
      let(:conditional_answer) { { nominated_for_award: "yes" } }

      let(:awards) do
        [
          {title: "Award1", details: "Details1"},
          {title: "Award2", details: "Details2"}
        ]
      end

      include_context "non js form ep form awards"
    end
  end
end
