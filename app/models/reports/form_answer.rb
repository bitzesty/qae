# represents the FormAnswer object in report generation context
class Reports::FormAnswer
  attr_reader :obj, :award_form

  def initialize(form_answer)
    @obj = form_answer
    answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document || {})
    @award_form = @obj.award_form.decorate(answers: answers)
  end

  def call_method(methodname)
    return "not implemented" if methodname.blank?

    if respond_to?(methodname, true)
      send(methodname)
    elsif obj.respond_to?(methodname)
      obj.send(methodname)
    else
      "missing method"
    end
  end

  private

  def address_line1
    obj.user.company_address_first
  end

  def address_line2
    obj.user.company_address_second
  end

  def address_line3
    obj.user.company_city
  end

  def postcode
    obj.user.company_postcode
  end

  def telephone1
    obj.user.phone_number
  end

  def telephone2
    obj.user.company_phone_number
  end

  def percentage_complete
    obj.fill_progress_in_percents
  end

  def qae_info_source
    obj.user.qae_info_source
  end

  def qae_info_source_other
    obj.user.qae_info_source_other
  end

  def title
    obj.user.title
  end

  def first_name
    obj.user.first_name
  end

  def last_name
    obj.user.last_name
  end

  def head_email
    obj.user.email
  end

  def company_name
    obj.user.company_name
  end

  def business_sector
    if business_form?
      doc "business_sector"
    end
  end

  def business_sector_other
    if business_form?
      doc "business_sector_other"
    end
  end

  def qao_permission
    obj.user.subscribed_to_emails
  end

  def user_creation_date
    obj.user.created_at
  end

  def section1
    f_progress(award_form.steps[0])
  end

  def section2
    f_progress(award_form.steps[1])
  end

  def section3
    f_progress(award_form.steps[2])
  end

  def section4
    f_progress(award_form.steps[3])
  end

  def section5
    f_progress(award_form.steps[4])
  end

  def section6
    f_progress(award_form.steps[6])
  end

  def f_progress(p)
    return "-" unless p
    ((p.progress || 0) * 100).round.to_s + "%"
  end

  def business_form?
    obj.trade? || obj.innovation? || obj.development?
  end

  def promotion?
    obj.promotion?
  end

  def doc(key)
    obj.document[key]
  end
end
