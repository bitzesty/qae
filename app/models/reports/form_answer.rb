class Reports::FormAnswer
  include Reports::DataPickers::UserPicker
  include Reports::DataPickers::FormDocumentPicker
  include FormAnswersBasePointer

  attr_reader :obj,
              :answers,
              :award_form,
              :financial_data

  def initialize(form_answer, limited_access = false)
    @obj = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document)
    @award_form = form_answer.award_form.decorate(answers:)
    @financial_data = form_answer.financial_data || {}

    return if limited_access

    @moderated = pick_assignment("moderated")
    @primary = pick_assignment("primary")
    @secondary = pick_assignment("secondary")
    @case_summary = pick_assignment("case_summary")

    @secondary_assessor = @obj.secondary_assessor

    return if @obj.press_summary.blank?

    @press_summary = @obj.press_summary
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

  def press_contact_full_name
    if @press_summary.try(:name).present? && @press_summary.last_name.present?
      [
        @press_summary.title,
        @press_summary.name,
        @press_summary.last_name,
      ]
    else
      [
        @obj.document["press_contact_details_title"],
        @obj.document["press_contact_details_first_name"],
        @obj.document["press_contact_details_last_name"],
      ]
    end.map(&:presence).compact.join(" ")
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
    if po_sd_provided_actual_figures?
      "N/A - provided actual figures"
    else
      bool obj.audit_certificate.present?
    end
  end

  def ac_checked
    if po_sd_provided_actual_figures?
      "N/A"
    else
      bool obj.audit_certificate.try(:reviewed?)
    end
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

  def sic_code
    @obj.document["sic_code"]
  end

  def sic_code_description
    res = @obj.decorate.sic_code_name
    res.present? ? res.split("-").last.strip : ""
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
    @category ||= obj.class::AWARD_TYPE_FULL_NAMES[obj.award_type]
  end

  def business_form?
    @business_form ||= obj.business?
  end

  delegate :trade?, :development?, :promotion?, :innovation?, :mobility?, to: :obj

  def bool(var)
    var ? "Yes" : "No"
  end

  def rag(var)
    {
      "negative" => "R",
      "positive" => "G",
      "average" => "A",
    }[var]
  end

  def press_contact_tel
    @press_summary.try(:phone_number) || @obj.document["press_contact_details_telephone"]
  end

  def press_contact_email
    @press_summary.try(:email) || @obj.document["press_contact_details_email"]
  end

  def press_contact_notes
    @press_summary.try(:body)
  end

  def applicant_submitted_press_note
    return if @press_summary.blank?

    bool @press_summary.try(:applicant_submitted?)
  end

  def assessor_agreed_press_note
    return if @press_summary.blank?

    bool @press_summary.try(:submitted?)
  end

  def qao_agreed_press_note
    return if @press_summary.blank?

    bool @press_summary.try(:admin_sign_off?)
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

  def empty_column
    ""
  end

  def po_sd_provided_actual_figures?
    %w[mobility development].include?(obj.award_type) && obj.document["product_estimated_figures"] == "no"
  end

  def government_support
    if obj.innovation?
      obj.document["innovations_grant_funding"]
    else
      obj.document["received_grant"]
    end.presence.to_s.humanize
  end
end
