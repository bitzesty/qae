class Assessor::PressSummariesController < Assessor::BaseController
  after_action :log_event, only: [:create, :update, :submit, :signoff]
  include PressSummaryMixin
end
