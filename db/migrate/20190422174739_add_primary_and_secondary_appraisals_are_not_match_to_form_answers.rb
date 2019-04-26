class AddPrimaryAndSecondaryAppraisalsAreNotMatchToFormAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :form_answers, :discrepancies_between_primary_and_secondary_appraisals, :json
  end
end
