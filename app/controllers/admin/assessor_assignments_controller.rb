class Admin::AssessorAssignmentsController < Admin::BaseController
  after_action :log_event, only: [:update]
  include AssessorAssignmentContext
end
