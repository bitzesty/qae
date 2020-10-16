class Assessor::AssessmentSubmissionsController < Assessor::BaseController
  after_action :log_event, only: [:create, :unlock]
  include AssessmentSubmissionMixin
end
