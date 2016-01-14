require "prawn/measurement_extensions"

class AuditCertificatePdf < Prawn::Document
  include PdfAuditCertificates::General::SharedElements
  include FinancialTable
  include FormAnswersBasePointer

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

    @form_answer = form_answer.decorate
    @award_type = form_answer.award_type_full_name.downcase
    @award_type_full_name = "#{@form_answer.award_type_full_name} #{form_answer.award_year.year}"
    @company_name = @form_answer.company_name
    @financial_pointer = initialize_financial_pointer
    @audit_data = financial_pointer.data
    @step_questions = financial_pointer.financial_step.questions
    @filled_answers = financial_pointer.filled_answers

    generate!
  end

  def generate!
    render_content
  end

  def render_content
    render_first_page
    start_new_page
    render_second_page
  end

  def render_first_page
    render_main_header
    render_base_paragraph
    render_financial_table
    render_options_list
    render_user_filling_block
    render_footer_note
  end

  def render_second_page
    render_main_header
    render_revised_schedule
    render_financial_table
    render_explanation_of_the_changes
    render_additional_comments
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

  private

  def initialize_financial_pointer
    FormFinancialPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true
    })
  end
end
