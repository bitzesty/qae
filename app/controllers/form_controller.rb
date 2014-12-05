require 'qae_2014_forms'

class FormController < ApplicationController
  before_filter :authenticate_user!

  def new_innovation_form
    form_answer = FormAnswer.create!(:user => current_user, :award_type=>'innovation')
    redirect_to edit_form_url(form_answer)
  end

  def edit_form
    @form_answer = FormAnswer.for_user(current_user).find(params[:id])
    @form = @form_answer.award_form
    render template: 'qae_form/show' 
  end

  def autosave
    @form_answer = FormAnswer.for_user(current_user).find(params[:id])
    doc = ActiveSupport::JSON.decode(request.body.read)
    @form_answer.document = doc
    @form_answer.save!
    render :nothing => true
  end

end
