require 'qae_2014_forms'

class FormController < ApplicationController
  before_filter :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  before_filter :set_form_answer, :except => [:new_innovation_form, :new_international_trade_form, :new_sustainable_development_form]

  def new_innovation_form
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'innovation')
    redirect_to edit_form_url(form_answer)
  end

  def new_international_trade_form
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'trade')
    redirect_to edit_form_url(form_answer)
  end

  def new_sustainable_development_form
    form_answer = FormAnswer.create!(user: current_user, account: current_user.account, award_type: 'development')
    redirect_to edit_form_url(form_answer)
  end

  def edit_form
    if @form_answer.eligible?
      @form = @form_answer.award_form
      render template: 'qae_form/show'
    else
      redirect_to form_award_eligibility_url(form_id: @form_answer.id)
    end
  end

  def submit_form
    path_params = request.path_parameters
    doc = params.except(*path_params.keys)
    @form_answer.document = doc

    @form_answer.submitted = true
    @form_answer.save!
    redirect_to submit_confirm_url(@form_answer)
  end

  def submit_confirm
    load_eligibilities
    render template: 'qae_form/confirm'
  end

  def autosave
    @form_answer.document = ActiveSupport::JSON.decode(request.body.read)
    @form_answer.save!
    render :nothing => true
  end

  private

  def set_form_answer
    @form_answer = FormAnswer.for_account(current_user.account).find(params[:id])
  end
end
