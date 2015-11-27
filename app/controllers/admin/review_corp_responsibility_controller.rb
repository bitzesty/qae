class Admin::ReviewCorpResponsibilityController < Admin::BaseController
  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id]).decorate
  end

  include ReviewCorpResponsibilityMixin
end
