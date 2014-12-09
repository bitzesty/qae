class AddEligibilityAndBasicEligibilityToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :eligibility, :hstore
    add_column :form_answers, :basic_eligibility, :hstore
  end
end
