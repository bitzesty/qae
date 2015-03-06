require "prawn/measurement_extensions"

class AuditCertificatePdf < Prawn::Document
  include PdfAuditCertificates::General::SharedElements
  include FormAnswersBasePointer

  attr_reader :audit_data, :form_answer

  def initialize(form_answer)
    super()

    @form_answer = form_answer.decorate
    @audit_data = FormFinancialPointer.new(form_answer).data

    generate!
  end

  def generate!
    render_main_header
    render_content
  end

  def render_content
    render_first_page
    render_second_page
  end

  def render_first_page
    render_base_paragraph
    render_financial_table
    render_options_list
    render_user_filling_block
    render_footer_note
  end

  def render_second_page
    render_base_paragraph
    render_revised_schedule
    render_financial_table
    render_explanation_of_the_changes
    render_additional_comments
  end

  # def run
  #   audit_data.each do |question_block|
  #     question_key = question_block.keys.first.to_s
  #     question_data = question_block.values.first

  #     csv << (csv_section_header(question_key) + csv_data(question_data))
  #   end
  # end

  # def csv_general_headers
  #   [
  #     form_answer.award_application_title,
  #     form_answer.company_or_nominee_name
  #   ]
  # end

  # def csv_section_header(question_key)
  #   [QuestionLabels::AuditCertificateLabel.find(question_key).label]
  # end

  # def csv_data(question_data)
  #   question_data.map do |entry|
  #     if entry.is_a?(Array)
  #       entry.join("/")
  #     else
  #       entry[:value]
  #     end
  #   end
  # end
end
