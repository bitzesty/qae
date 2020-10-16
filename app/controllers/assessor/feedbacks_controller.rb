class Assessor::FeedbacksController < Assessor::BaseController
  after_action :log_event, only: [:create, :update, :destroy, :submit, :unlock]
  include FeedbackMixin
end
