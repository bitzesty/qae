class Reports::FormAnswer
  include Reports::DataPickers::UserPicker
  include Reports::DataPickers::FormDocumentPicker
  include FormAnswersBasePointer

  attr_reader :obj,
              :answers,
              :award_form,
              :financial_data

  def initialize(form_answer)
    @obj = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document)
    @award_form = form_answer.award_form.decorate(answers: answers)
    @financial_data = form_answer.financial_data || {}

    @moderated = pick_assignment("moderated")
    @primary = pick_assignment("primary")
    @secondary = pick_assignment("secondary")
    @case_summary = pick_assignment("case_summary")

    @secondary_assessor = @obj.secondary_assessor
    @press_summary = @obj.press_summary if @obj.awarded?
  end

  def question_visible?(question_key)
    question = award_form[question_key.to_sym]
    question.blank? || question.visible?(answers)
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
    obj.feedback && obj.feedback.submitted? && obj.feedback.locked? ? "Submitted" : "Not Submitted"
  end

  def press_release_updated
    obj.press_summary && obj.press_summary.submitted ? "Submitted" : "Not Submitted"
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
    rag(@case_summary.try(:verdict_rate))
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
    @press_summary.try(:body)
  end

  def customer_submitted_press_note
    if @press_summary.present?
      bool @press_summary.try(:reviewed_by_user?)
    end
  end

  def qao_agreed_press_note
    if @press_summary.present?
      bool @press_summary.try(:submitted?)
    end
  end

  def case_summary_status
    if @case_summary.try(:submitted?) && @case_summary.locked?
      "Submitted"
    else
      "Not Submitted"
    end
  end

  def overall_status
    obj.state.humanize
  end
end
