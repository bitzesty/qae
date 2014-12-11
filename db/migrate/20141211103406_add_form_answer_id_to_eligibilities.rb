class AddFormAnswerIdToEligibilities < ActiveRecord::Migration
  def change
    add_reference :eligibilities, :form_answer, index: true
  end
end
