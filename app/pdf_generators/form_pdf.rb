require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  include QaePdfForms::General::DrawElements
  include FormAnswersBasePointer

  UNDEFINED_TITLE = "No answer ..."
  UNDEFINED_TYPE = "undefined type UNDEFINED"
  TABLE_WITH_COMMENT_QUESTION = %w(financial_year_dates total_turnover exports net_profit total_net_assets)
  INLINE_DATE_QUESTION = %w(started_trading financial_year_date nominee_date_of_birth)
  JUST_NOTES = [
    "QAEFormBuilder::HeaderQuestion"
  ]
  DEFAULT_ANSWER_COLOR = "5B5656"

  attr_reader :user,
              :form_answer,
              :award_form,
              :steps,
              :all_questions,
              :answers,
              :filled_answers,
              :form_answer_attachments,
              :financial_pointer,
              :pdf_blank_mode

  def initialize(form_answer, pdf_blank_mode=false)
    super()

    @form_answer = form_answer
    @user = form_answer.user
    @pdf_blank_mode = pdf_blank_mode
    @answers = fetch_answers(pdf_blank_mode)

    @award_form = form_answer.award_form.decorate(answers: answers)
    @steps = award_form.steps
    @all_questions = steps.map(&:questions).flatten
    @form_answer_attachments = form_answer.form_answer_attachments.select do |a|
      a.scan.present? && a.scan.clean?
    end
    @filled_answers = fetch_filled_answers
    @financial_pointer = FormFinancialPointer.new(@form_answer.decorate)

    generate!
  end

  def generate!
    main_header

    steps.each do |step|
      QaePdfForms::General::StepPointer.new(award_form: award_form,
                                            form_pdf: self,
                                            step: step).render!
    end
  end
end
