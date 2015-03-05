class FormAnswerDecorator < ApplicationDecorator

  SELECT_BOX_LABELS = FormAnswer::AWARD_TYPE_FULL_NAMES.merge("promotion" => "QAEP")

  AWARD_TITLES = { "Innovation" => "Innovation",
                   "International Trade" => "Intl Trade",
                   "Sustainable Development" => "Sus Dev",
                   "Enterprise promotion" => "QAEP",
                   "QAEP" => "QAEP"
                 }

  def pdf_generator
    "QaePdfForms::Awards2014::#{object.award_type.capitalize}::Base".constantize.new(object)
  end

  def download_filename
    "#{object.award_type}_award_#{created_at}"
  end

  def pdf_filename
    "#{download_filename}.pdf"
  end

  def csv_filename
    "#{object.id}_#{download_filename}.csv"
  end

  def award_type
    object.class::AWARD_TYPE_FULL_NAMES[object.award_type]
  end

  def application_name
    object.nickname || award_type
  end

  def award_type_short_name
    AWARD_TITLES[object.class::AWARD_TYPE_FULL_NAMES[object.award_type]]
  end

  def award_application_title
    "#{award_type} Award #{Date.today.year}"
  end

  def company_or_nominee_name
    object.company_or_nominee_name
  end

  def company_name
    company_or_nominee_name
  end

  def progress_class
    "#{object.state.dasherize[0..-2]}"
  end

  def progress_text_short
    "#{object.state.humanize[0..-2]}"
  end

  def progress_text
    "#{progress_text_short}...#{fill_progress_in_percents}"
  end

  def average_growth_for(year)
    if object.sic_code.present?
      sic = SICCode.find_by_code(object.sic_code)
      sic.by_year(year) if sic
    end
  end

  def all_average_growths
    res = {}
    (1..6).each { |y| res[y] = average_growth_for(y) }
    res
  end

  def sic_code_name
    sic = object.sic_code
    if sic.present?
      SICCode.find_by_code(sic).name
    end
  end

  def average_growth_legend(years = [1, 2, 3])
    growths = years.map { |y| average_growth_for(y) }.uniq
    growths.map do |g|
      note = SICCode::NOTES[g]
      "#{g} - #{note}" if note
    end.compact.join("\n")
  end
end
