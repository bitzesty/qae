class AddEligibilityAndBasicEligibilityToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :eligibility, :hstore
    add_column :form_answers, :basic_eligibility, :hstore
  end
end
