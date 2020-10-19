class Assessor::AssessorAssignmentsController < Assessor::BaseController
  after_action :log_event, only: [:update]
  include AssessorAssignmentContext
end
