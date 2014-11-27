# == Schema Information
#
# Table name: answers
#
#  id                 :integer          not null, primary key
#  form_response_id   :integer
#  question_id        :integer
#  question_option_id :integer
#  input              :string(255)
#  area               :text
#  date_value         :date
#  file               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Answer < ActiveRecord::Base
  begin :associations 
    belongs_to :form_response
    belongs_to :question
    belongs_to :question_option
  end

  begin :validations
    validates :form_response, :question, presence: true
  end
end
