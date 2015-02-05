require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  include QaePdfForms::General::DrawElements

  UNDEFINED_TITLE = "in the progress of filling.."
  UNDEFINED_TYPE = "undefined type UNDEFINED"
  TABLE_WITH_COMMENT_QUESTION = [
    'financial_year_dates',
    'total_turnover',
    'exports',
    'net_profit',
    'total_net_assets'
  ]
  INLINE_DATE_QUESTION = [
    'started_trading',
    'financial_year_date'
  ]
  JUST_NOTES = [
    "QAEFormBuilder::HeaderQuestion"
  ]
  HIDDEN_QUESTIONS = [
    "agree_to_be_contacted",
    "contact_email_confirmation",
    "entry_confirmation"
  ]

  attr_reader :user,
              :form_answer,
              :award_form,
              :steps,
              :answers,
              :filled_answers,
              :form_answer_attachments

  def initialize(form_answer)
    super()

    @form_answer = form_answer
    @user = form_answer.user
    @answers = fetch_answers

    @award_form = form_answer.award_form.decorate(answers: answers)
    @steps = award_form.steps
    @form_answer_attachments = form_answer.form_answer_attachments
    @filled_answers = fetch_filled_answers

    generate!
  end

  def generate!
    main_header

    steps.each do |step|
      QaePdfForms::General::StepPointer.new({
        award_form: award_form,
        form_pdf: self,
        step: step
      }).render!
    end
  end

  def fetch_answers
    ActiveSupport::HashWithIndifferentAccess.new(form_answer.document).select do |key, value|
      !HIDDEN_QUESTIONS.include?(key.to_s)
    end
  end

  def fetch_filled_answers
    answers.reject do |key, value|
      value.blank?
    end
  end

  def answers_by_key(key)
    filled_answers.select do |key, value|
      key.include?(key.to_s)
    end
  end

  def at_least_of_one_answer_by_key?(key)
    answers_by_key(key).any?
  end

  def fetch_answer_by_key(key)
    begin
      JSON.parse(answers[key])
    rescue
      answers[key]
    end
  end

  def answer_based_on_type(key, value)
    if key.to_s.include?('country')
      ISO3166::Country.countries.select do |country|
        country[1] == value.strip
      end[0][0]
    else
      value
    end
  end
end
