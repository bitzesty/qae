# == Schema Information
#
# Table name: form_steps
#
#  id          :integer          not null, primary key
#  form_id     :integer
#  title       :string(255)
#  description :text
#  note        :text
#  placement   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class FormStep < ActiveRecord::Base
  begin :associations 
    belongs_to :form

    has_many :questions, dependent: :destroy
  end

  begin :validations
    validates :title, :placement, presence: true
  end
end
