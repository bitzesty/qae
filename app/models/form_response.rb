# == Schema Information
#
# Table name: form_responses
#
#  id          :integer          not null, primary key
#  form_id     :integer
#  user_id     :integer
#  devise_type :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class FormResponse < ActiveRecord::Base
  begin :associations 
    belongs_to :form
    belongs_to :user

    has_many :answers, dependent: :destroy
  end

  begin :validations
    validates :user, :form, presence: true
  end
end
