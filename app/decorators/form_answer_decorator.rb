class FormAnswerDecorator < ApplicationDecorator
  def pdf_generator
    "QaePdfForms::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def pdf_filename
    "#{object.award_type}_award_#{object.decorate.created_at}.pdf"
  end

  def award
    case object.award_type
    when "trade"
      'International Trade Award'
    when "innovation"
      'Innovation Award'
    when "development"
      'Sustainable Development Award'
    when "promotion" 
      'Enterprise promotion Award'
    end
  end

  def award_application_title
    "#{award} #{Date.today.year}"
  end
end