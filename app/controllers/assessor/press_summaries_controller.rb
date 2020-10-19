class Assessor::PressSummariesController < Assessor::BaseController
  after_action :log_event, only: [:update, :signoff]
  include PressSummaryMixin
end
