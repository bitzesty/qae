class RemoveCorpResponsibilitySubmittedFromFormAnswers < ActiveRecord::Migration
  def change
    remove_column :form_answers, :corp_responsibility_submitted
  end
end
