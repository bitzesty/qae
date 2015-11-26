class AddCorpResponsibilityReviewedToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :corp_responsibility_reviewed, :boolean, default: false
  end
end
