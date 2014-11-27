# == Schema Information
#
# Table name: question_options
#
#  id          :integer          not null, primary key
#  question_id :integer
#  title       :text
#  input       :text
#  with_input  :boolean
#  placement   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class QuestionOption < ActiveRecord::Base
  begin :associations 
    belongs_to :question
  end

  begin :validations
    validates :title, :placement, presence: true
  end
end
