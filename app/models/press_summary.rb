class PressSummary < ActiveRecord::Base
  belongs_to :form_answer

  validates :form_answer, :body, presence: true
end
