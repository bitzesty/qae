class Admin::PressSummariesController < Admin::BaseController
  after_action :log_event, only: [:create, :update, :signoff]
  include PressSummaryMixin
end
