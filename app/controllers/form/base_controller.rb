class Form::BaseController < ApplicationController
  before_action :authenticate_user!

  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  before_action :load_form_answer

  private

  def load_form_answer
    @form_answer = current_user.account.form_answers.find(params[:form_answer_id])
    @form = @form_answer.award_form.decorate(
      answers: HashWithIndifferentAccess.new(@form_answer.document),
    )
  end
end
