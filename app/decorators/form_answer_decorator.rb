class FormAnswerDecorator < ApplicationDecorator
  AWARD_TYPE_LABELS = {
    'innovation' => 'Innovation',
    'trade' => 'International Trade',
    'development' => 'Sustainable Development',
    'promotion' => 'Enterprise promotion'
  }

  SELECT_BOX_LABELS = AWARD_TYPE_LABELS.merge({'promotion' => 'QAEP'})

  def pdf_generator
    "QaePdfForms::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def pdf_filename
    "#{object.award_type}_award_#{object.decorate.created_at}.pdf"
  end

  def award_type
    AWARD_TYPE_LABELS[object.award_type]
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