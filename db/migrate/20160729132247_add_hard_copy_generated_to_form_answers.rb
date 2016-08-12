class AddHardCopyGeneratedToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :hard_copy_generated, :boolean, default: false
  end
end
