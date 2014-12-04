require 'qae_2014_forms'

class FormController < ApplicationController
  before_filter :authenticate_user!

  def innovation
    @form = QAE2014Forms.innovation
    render template: 'qae_form/show' 
  end

  def autosave
    answer = ActiveSupport::JSON.decode(request.body.read)
    puts answer.inspect
    render :nothing => true
  end

end
