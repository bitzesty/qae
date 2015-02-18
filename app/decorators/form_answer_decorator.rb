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

  def company_or_nominee
    object.user.company_name
  end

  def company_name
    company_or_nominee
  end

  def progress_text
    # IMPLEMENTME
    'Application...30%'
  end

  def consideration_status_label
    if object.withdrawn?
      'withdrawn'
    else
      # IMPLEMENTME
      ['pending', 'shortlisted'][rand(2)]
    end
  end
end