class AddFormAnswerIdToEligibilities < ActiveRecord::Migration[4.2]
  def change
    add_reference :eligibilities, :form_answer, index: true
  end
end
