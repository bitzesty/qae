require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  include QaePdfForms::General::Base

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
  HIDDEN_QUESTIONS = [
    "agree_to_be_contacted",
    "contact_email_confirmation",
    "entry_confirmation"
  ]
  JUST_NOTES = [
    "QAEFormBuilder::HeaderQuestion"
  ]

  attr_reader :user, :form_answer, :answers, :award_form, :steps, :all_steps_questions, :form_answer_attachments, :filled_answers

  def initialize(form_answer)
    super()
    @form_answer = form_answer
    @award_form = form_answer.award_form
    @user = form_answer.user

    @steps = award_form.steps
    @form_answer_attachments = form_answer.form_answer_attachments
    @answers = ActiveSupport::HashWithIndifferentAccess.new(form_answer.document).select do |key, value|
      !HIDDEN_QUESTIONS.include?(key.to_s)
    end
    @filled_answers = @answers.reject do |key, value|
      value.blank?
    end
    
    generate!
  end

  def filtered_questions(cached_questions)
    cached_questions.select do |question|
      !HIDDEN_QUESTIONS.include?(question.key.to_s) &&
      allowed_by_or_have_no_conditions?(cached_questions, question)
    end
  end

  def allowed_by_or_have_no_conditions?(cached_questions, question)
    conditions = question.conditions
    drop_condition_keys = cached_questions.select do |q| 
      q.drop_condition.present? && 
      q.drop_condition == question.key
    end.map(&:key)

    (
      conditions.blank? ||
      conditions.all? do |condition|
        conditional_success?(question, cached_questions, condition)
      end
    ) &&
    (
      drop_condition_keys.blank? ||
      drop_condition_keys.any? do |condition_key|
        visibility_allowed_by_drop_condition?(condition_key)
      end
    )
  end

  def conditional_success?(question, cached_questions, condition)
    question_key = condition.question_key
    question_value = condition.question_value
    parent_question_answer = fetch_answer_by_key(question_key)

    if question_value == :true
      parent_question_answer.present?
    else
      parent_question_answer == question_value.to_s
    end
  end

  def visibility_allowed_by_drop_condition?(condition_key)
    answers_by_key(condition_key).any? do |k, v|
      v.present?
    end
  end

  def answers_by_key(condition_key)
    filled_answers.select do |key, value|
      key.include?(condition_key.to_s)
    end
  end

  def generate!
    main_header

    steps.each_with_index do |step, index|
      render_step(step, index)
    end
  end

  def render_step(step, index)
    start_new_page if index.to_i != 0

    step_header(step)
    cached_questions = step.questions.reject do |question|
      HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    filtered_questions(cached_questions).each do |question|
      render_question(cached_questions, question) 
    end
  end

  def render_question(cached_questions, question)
    answer = humanized_answer(question)
    sub_answers = fetch_sub_answers(cached_questions, question)

    if answer.present?
      question_block(question, answer)
    else
      if sub_answers.any?
        complex_question(question, sub_answers)
      else
        question_block(question)
      end
    end
  end

  def question_block(question, answer=nil)
    default_bottom_margin
    text question.decorate.escaped_title, style: :bold

    if !JUST_NOTES.include?(question.class.to_s)
      case question.class.to_s
      when "QAEFormBuilder::UploadQuestion" 
        render_attachment_question(question, answer)
      when "QAEFormBuilder::OptionsQuestion" 
        default_bottom_margin
        text (answer.present? ? question_option_title(question, answer) : UNDEFINED_TITLE), style: :italic
      when "QAEFormBuilder::ConfirmQuestion"
        default_bottom_margin
        text (answer.present? ? question_checked_value_title(question, answer) : UNDEFINED_TITLE), style: :italic
      else
        default_bottom_margin
        text (answer.present? ? answer : UNDEFINED_TITLE), style: :italic
      end
    end
  end

  def question_option_title(question, answer)
    question.options.select do |option| 
      option.value.to_s == answer.to_s
    end.first.text
  end

  def question_checked_value_title(question, answer)
    Nokogiri::HTML.parse(question.text).text.strip if answer == 'on'
  end

  def render_attachment_question(question, answer=nil)
    if answer.present?
      attachments = answer

      attachments.each do |k, v| 
        attachment_by_type(k, v)
      end
    else
      default_bottom_margin
      text UNDEFINED_TITLE, style: :italic 
    end
  end

  def attachment_by_type(k, v)
    if v.keys.include?('file')
      attachment = form_answer_attachments.find(v['file'])
      draw_link_with_file_attachment(attachment, v['description'])
    elsif v.keys.include?('link')
      draw_link(v)
    else
      raise UNDEFINED_TYPE
    end
  end

  def complex_question(question, sub_answers)
    default_bottom_margin
    text question.decorate.escaped_title, style: :bold

    if sub_answers.length > 1
      sub_answers_by_type(question, sub_answers)
    else
      first_sub_question = sub_answers[0][1]
      sub_question_block_without_title(first_sub_question)
    end
  end

  def sub_answers_by_type(question, sub_answers)
    case question.key.to_s
    when *TABLE_WITH_COMMENT_QUESTION
      render_table_with_optional_extra(sub_answers)
    when *INLINE_DATE_QUESTION
      render_inline_date(sub_answers)
    else
      sub_answers_standart_render(sub_answers)
    end
  end

  def sub_answers_standart_render(sub_answers)
    sub_answers.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer) if sub_answer.present?
    end
  end

  def render_table_with_optional_extra(sub_answers)
    cells = sub_answers.select do |a|
      a[0].match(/\/{1}[0-9]{2}\/{1}/).present? ||
      a[0].match(/Year/).present?
    end

    if cells.present?
      headers = cells.map { |a| a[0] }
      row = cells.map { |a| a[1] }
      render_simple_table(headers, row)
    end

    comments = sub_answers - cells
    sub_answers_standart_render(comments) if comments.present?
  end

  def render_inline_date(sub_answers)
    headers = sub_answers.map { |a| a[0] }
    row = sub_answers.map { |a| a[1] }
    row[1] = Date::MONTHNAMES[row[1].to_i] if row[1].present?
    render_simple_table(headers, row)
  end

  def render_simple_table(headers, row)
    table_lines = [headers, row]
    render_table(table_lines)
  end

  def render_table(table_lines)
    default_bottom_margin
    table table_lines, row_colors: ["F0F0F0", "FFFFFF"],
                       cell_style: { size: 10, font_style: :bold }
  end

  def sub_question_block(sub_question, sub_answer)
    default_bottom_margin
    text sub_question, style: :bold
    
    default_bottom_margin
    text sub_answer, style: :italic
  end

  def sub_question_block_without_title(sub_answer)
    default_bottom_margin
    text sub_answer, style: :italic
  end

  def fetch_sub_answers(cached_questions, question)
    question_main_key = question.key.to_s
    res = []

    question.decorate.required_sub_fields.each do |sub_field|
      sub_field_key = sub_field.keys.first
      sub_field_title = sub_field[sub_field_key]

      answer = fetch_answer_by_key("#{question_main_key}_#{sub_field_key}")

      res << [
        sub_field_title, 
        answer ? answer_based_on_type(sub_field_key, answer) : UNDEFINED_TITLE
      ]
    end

    res
  end

  def fetch_answer(question)
    fetch_answer_by_key(question.key)
  end

  def fetch_answer_by_key(key)
    begin
      JSON.parse(answers[key])
    rescue
      answers[key]
    end
  end

  def humanized_answer(question)
    value = fetch_answer(question)
    value = answer_based_on_type(question.key, value) if value.present?
    value
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

  private

  def log_this(m)
    unless Rails.env.production?
      Rails.logger.info m
    end
  end
end