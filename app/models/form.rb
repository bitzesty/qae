# == Schema Information
#
# Table name: forms
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Form < ActiveRecord::Base
  begin :associations 
    has_many :form_steps, dependent: :destroy
  end

  begin :validations
    validates :title, :placement, presence: true
  end
end
