class AddCorpResponsibilityReviewedToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :corp_responsibility_reviewed, :boolean, default: false
  end
end
