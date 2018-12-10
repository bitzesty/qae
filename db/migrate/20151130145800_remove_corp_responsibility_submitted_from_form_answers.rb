class RemoveCorpResponsibilitySubmittedFromFormAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :form_answers, :corp_responsibility_submitted
  end
end
