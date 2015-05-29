class Reports::FormAnswer
  include Reports::DataPickers::UserPicker
  include Reports::DataPickers::FormDocumentPicker

  attr_reader :obj, :award_form

  def initialize(form_answer)
    @obj = form_answer

    @moderated = pick_assignment("moderated")
    @primary = pick_assignment("primary")
    @secondary = pick_assignment("secondary")
    @lead_case_summary = pick_assignment("lead_case_summary")
    @primary_case_summary = pick_assignment("primary_case_summary")

    @secondary_assessor = @obj.secondary_assessor
    @press_summary = @obj.press_summary if @obj.awarded?
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

  def pick_assignment(name)
    @obj.assessor_assignments.detect { |a| a.position == name }
  end

  def feedback_complete
    bool(obj.feedback.present?)
  end

  def ac_received
    bool obj.audit_certificate.present?
  end

  def ac_checked
    bool obj.audit_certificate.try(:reviewed?)
  end

  def case_assigned
    bool(obj.primary_assessor_id.present? && obj.secondary_assessor_id.present?)
  end

  def case_withdrawn
    bool obj.withdrawn?
  end

  def percentage_complete
    obj.fill_progress_in_percents
  end

  def mso_outcome_agreed
    rag @moderated.try(:verdict_rate)
  end

  def mso_grade_agreed
    return unless @moderated
    rates = @moderated.document.select { |k, _| k =~ /\w_rate/ }
    rates.map do |_, rate|
      rag rate
    end.join(",")
  end

  def first_assessor
    @obj.primary_assessor.try(:full_name)
  end

  def second_assessor
    @secondary_assessor.try(:full_name)
  end

  def first_assessment_complete
    bool(@primary.try(:submitted?))
  end

  def second_assessment_complete
    bool(@secondary.try(:submitted?))
  end

  def case_summary_overall_grade
    rag(@lead_case_summary.try(:verdict_rate))
  end

  def section1
    obj.form_answer_progress.try(:section, 1)
  end

  def section2
    obj.form_answer_progress.try(:section, 2)
  end

  def section3
    obj.form_answer_progress.try(:section, 3)
  end

  def section4
    obj.form_answer_progress.try(:section, 4)
  end

  def section5
    obj.form_answer_progress.try(:section, 5)
  end

  def section6
    obj.form_answer_progress.try(:section, 6)
  end

  def category
    obj.class::AWARD_TYPE_FULL_NAMES[obj.award_type]
  end

  def business_form?
    obj.trade? || obj.innovation? || obj.development?
  end

  def trade?
    obj.trade?
  end

  def development?
    obj.development?
  end

  def promotion?
    obj.promotion?
  end

  def innovation?
    obj.innovation?
  end

  def bool(var)
    var ? "Yes" : "No"
  end

  def rag(var)
    {
      "negative" => "R",
      "positive" => "G",
      "average" => "A"
    }[var]
  end

  def press_contact_name
    @press_summary.try(:contact_name)
  end

  def press_contact_tel
    @press_summary.try(:phone_number)
  end

  def press_contact_email
    @press_summary.try(:email)
  end

  def press_contact_notes
    @press_summary.try(:comment)
  end

  def customer_accepted_press_note
    if @press_summary.present?
      bool @press_summary.try(:reviewed_by_user?)
    end
  end

  def qao_agreed_press_note
    if @press_summary.present?
      bool @press_summary.try(:approved?)
    end
  end

  def case_summary_status
    lead_submitted = @lead_case_summary.try(:submitted?)
    primary_submitted = @primary_case_summary.try(:submitted?)

    if !primary_submitted && !lead_submitted
      "Not Submitted"
    elsif primary_submitted && !lead_submitted
      "Primary Submitted"
    elsif lead_submitted
      "Lead Confirmed"
    end
  end
end
