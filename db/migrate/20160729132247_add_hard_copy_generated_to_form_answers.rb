class AddHardCopyGeneratedToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :hard_copy_generated, :boolean, default: false
  end
end
