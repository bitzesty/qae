class Feedback < ActiveRecord::Base
  belongs_to :form_answer

  store_accessor :document, FeedbackForm.fields
end
