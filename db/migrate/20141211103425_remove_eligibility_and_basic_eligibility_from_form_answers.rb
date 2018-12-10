class RemoveEligibilityAndBasicEligibilityFromFormAnswers < ActiveRecord::Migration[4.2]
  def up
    remove_column :form_answers, :eligibility
    remove_column :form_answers, :basic_eligibility
  end

  def down
    add_column :form_answers, :eligibility, :hstore
    add_column :form_answers, :basic_eligibility, :hstore
  end
end
