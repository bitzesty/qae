class Admin::AssessmentSubmissionsController < Admin::BaseController
  include AssessmentSubmissionMixin

  after_action :log_event, only: [:create, :unlock]
end
