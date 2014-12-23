class FormAnswerDecorator < ApplicationDecorator
  def pdf_generator
    "QaePdfForms::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def pdf_filename
    "#{object.award_type}_award_#{object.decorate.created_at}.pdf"
  end

  def award_type
    case object.award_type
    when "trade"
      'International Trade'
    when "innovation"
      'Innovation'
    when "development"
      'Sustainable Development'
    when "promotion" 
      'Enterprise promotion'
    end
  end

  def award_application_title
    "#{award_type} Award #{Date.today.year}"
  end
end