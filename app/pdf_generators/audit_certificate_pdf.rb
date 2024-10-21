require "prawn/measurement_extensions"

class AuditCertificatePdf < Prawn::Document
  include PdfAuditCertificates::General::SharedElements
  include PdfAuditCertificates::General::GuidanceElements
  include FinancialTable
  include FormAnswersBasePointer
  include SharedPdfHelpers::FontHelper
  include SharedPdfHelpers::LanguageHelper

  attr_reader :audit_data,
    :form_answer,
    :award_type,
    :award_type_full_name,
    :company_name,
    :financial_pointer,
    :step_questions,
    :filled_answers

  def initialize(form_answer)
    super()

    @form_answer = initialize_form_answer(form_answer)
    @award_type = form_answer.award_type_full_name.downcase
    @award_type_full_name = "#{@form_answer.award_type_full_name} #{form_answer.award_year.year}"
    @company_name = @form_answer.company_name
    @financial_pointer = FinancialSummaryPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true,
    })
    @audit_data = financial_pointer.data
    @step_questions = financial_pointer.financial_step.questions
    @filled_answers = financial_pointer.filled_answers
    set_fonts!
    set_language!
    generate!
  end

  def generate!
    render_content
    add_page_numbers
  end

  def render_content
    render_main_header
    render_report_intro
    render_applicant_guidance_section
    render_accountant_guidance_section
    render_financial_table
    render_explanation_of_the_changes

    start_new_page
    render_additional_comments
    render_accountant_statement
    render_user_filling_block
    render_applicants_management_statement
    render_feedback

    start_new_page
    render_appendix
  end

  def formatted_uk_sales_value(item)
    ApplicationController.helpers.formatted_uk_sales_value(item)
  end

  def number_with_delimiter(item)
    ApplicationController.helpers.number_with_delimiter(item)
  end

  def financials_i18_prefix
    "admin.form_answers.financial_summary"
  end

  def add_page_numbers
    number_pages "<page>", {
      start_count_at: 1,
      at: [
        bounds.right - 50,
        bounds.bottom + 0,
      ],
      align: :right,
      size: 14,
    }
  end

  def award_type_short
    award_name = self.class.name.deconstantize.split("::").last
    I18n.t("pdf_texts.audit_certificates").dig(award_name.to_sym, :award_type_short) || award_name.titleize
  end

  private

  def initialize_form_answer(form)
    form.decorate
  end
end
