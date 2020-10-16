class Assessor::FormAnswerAttachmentsController < Assessor::BaseController
  after_action :log_event, only: [:create, :destroy]
  include ::FormAnswerAttachmentsContext
end
