class FormAnswerAssessment < ActiveRecord::Base
  belongs_to :assessor_assignment

  store_accessor :document, *Assessment::AppraisalForm.all
end
