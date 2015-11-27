class Assessor::ReviewCorpResponsibilityController < Assessor::BaseController
  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id]).decorate
  end

  expose(:corp_responsibility_reviewed) do
    params[:form_answer][:corp_responsibility_reviewed].to_s == "1"
  end

  include ReviewCorpResponsibilityMixin
end
