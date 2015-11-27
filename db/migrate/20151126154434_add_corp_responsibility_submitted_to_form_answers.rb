class AddCorpResponsibilitySubmittedToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :corp_responsibility_submitted, :boolean, default: false
  end
end
