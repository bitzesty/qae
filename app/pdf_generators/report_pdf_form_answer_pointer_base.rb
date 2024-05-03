require "prawn/measurement_extensions"

class ReportPdfFormAnswerPointerBase
  include SharedPdfHelpers::DrawElements
  include SharedPdfHelpers::DataHelpers
  include FormAnswersBasePointer

  UNDEFINED_VALUE = "..."

  attr_reader :user,
              :form_answer,
              :award_form,
              :all_questions,
              :answers,
              :filled_answers,
              :data,
              :pdf_doc,
              :award_year

  def initialize(pdf_doc, form_answer)
    @pdf_doc = pdf_doc
    @award_year = pdf_doc.award_year
    @form_answer = form_answer
    @user = form_answer.user
    @answers = fetch_answers
    @award_form = form_answer.award_form.decorate(answers:)
    @all_questions = award_form.steps.map(&:questions).flatten
    @filled_answers = fetch_filled_answers

    generate!
  end

  def generate!
    main_header
    render_data!
  end
end
