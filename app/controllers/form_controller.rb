require 'qae_2014_forms'

class FormController < ApplicationController
  before_filter :authenticate_user!
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
    @form = @form_answer.award_form
    render template: 'qae_form/show'
  end

  def submit_form
    path_params = request.path_parameters
    doc = params.except(*path_params.keys).except(:eligibility, :basic_eligibility)
    @form_answer.document = doc
    @form_answer.eligibility = params[:eligibility]
    @form_answer.basic_eligibility = params[:basic_eligibility]

    @form_answer.submitted = true
    @form_answer.save!
    redirect_to submit_confirm_url(@form_answer)
  end

  def submit_confirm
    render template: 'qae_form/confirm'
  end

  def autosave
    extracted_params = extract_params(request.body.read)

    @form_answer.document = extracted_params[:doc]
    @form_answer.eligibility = extracted_params[:eligibility]
    @form_answer.basic_eligibility = extracted_params[:basic_eligibility]
    @form_answer.save!
    render :nothing => true
  end

  private

  def set_form_answer
    @form_answer = FormAnswer.for_account(current_user.account).find(params[:id])
  end

  def extract_params(body)
    doc = ActiveSupport::JSON.decode(body)
    eligibility = {}
    basic_eligibility = {}

    doc.reject! do |q, a|
      if q.match(/\Aeligibility\[/)
        eligibility[q.gsub(/eligibility\[(\w*)\]/, '\1')] = a

        true
      elsif q.match(/\Abasic_eligibility\[/)
        basic_eligibility[q.gsub(/basic_eligibility\[(\w*)\]/, '\1')] = a

        true
      end
    end

    { doc: doc, eligibility: eligibility, basic_eligibility: basic_eligibility }
  end
end
