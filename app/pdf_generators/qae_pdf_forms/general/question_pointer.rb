class QaePdfForms::General::QuestionPointer
  include QaePdfForms::CustomQuestions::ByYear
  include QaePdfForms::CustomQuestions::Lists
  include QaePdfForms::CustomQuestions::SupporterLists
  include FinancialTable

  NOT_CURRENCY_QUESTION_KEYS = %w(employees)

  attr_reader :form_pdf,
              :form_answer,
              :step,
              :question,
              :key,
              :answer,
              :humanized_answer,
              :sub_answers,
              :financial_pointer,
              :audit_data,
              :filled_answers,
              :step_questions,
              :questions_with_references,
              :children_conditions

  PREVIOUS_AWARDS = { "innovation_2" => "Innovation (2 years)",
                      "innovation_5" => "Innovation (5 years)",
                      "international_trade_3" => "International Trade (3 years)",
                      "international_trade_6" => "International Trade (6 years)",
                      "sustainable_development_2" => "Sustainable Development (2 years)",
                      "sustainable_development_5" => "Sustainable Development (5 years)" }

  ANSWER_FONT_START = "<font name='Times-Roman'><color rgb='999999'>"
  ANSWER_FONT_END = "</font></color>"

  BLOCK_QUESTIONS = [
    QAEFormBuilder::AwardHolderQuestion,
    QAEFormBuilder::QueenAwardHolderQuestion,
    QAEFormBuilder::PositionDetailsQuestion,
    QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion,
    QAEFormBuilder::ByTradeGoodsAndServicesLabelQuestion,
    QAEFormBuilder::UploadQuestion,
    QAEFormBuilder::ByYearsLabelQuestion,
    QAEFormBuilder::ByYearsQuestion,
    QAEFormBuilder::SupportersQuestion,
    QAEFormBuilder::TextareaQuestion
  ]

  def initialize(ops = {})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @key = question.key
    @answer = answer_by_key
    @humanized_answer = form_pdf.answer_based_on_type(key, answer) if answer.present?
    @sub_answers = fetch_sub_answers
    @financial_pointer = form_pdf.financial_pointer
    @audit_data = financial_pointer.data
    @filled_answers = form_pdf.filled_answers
    @step_questions = step.step_questions
    @form_answer = form_pdf.form_answer

    set_questions_with_references
    set_children_conditions
  end

  def set_questions_with_references
    @questions_with_references = form_pdf.all_questions.select do |q|
      !q.delegate_obj.is_a?(QAEFormBuilder::HeaderQuestion) &&
      (q.ref.present? || q.sub_ref.present?)
    end
  end

  def set_children_conditions
    @children_conditions = question.children_conditions(questions_with_references)
  end

  def render!
    if humanized_answer.present?
      question_block
    else
      sub_answers.any? ? complex_question : question_block
    end

    render_bottom_space
  end

  def render_bottom_space
    if question.delegate_obj.class.to_s != "QAEFormBuilder::HeaderQuestion" ||
       question.classes != "regular-question" ||
       question.classes == "application-notice help-notice"

      form_pdf.default_bottom_margin
    end
  end

  def answer_by_key
    JSON.parse(form_pdf.answers[key])
  rescue
    form_pdf.answers[key]
  end

  def fetch_sub_answers
    res = []

    question.required_sub_fields.each do |sub_field|
      sub_field_key = sub_field.keys.first
      sub_answer = form_pdf.fetch_answer_by_key("#{key}_#{sub_field_key}")

      res << [
        sub_field[sub_field_key],
        sub_answer ? form_pdf.answer_based_on_type(sub_field_key, sub_answer) : FormPdf::UNDEFINED_TITLE
      ]
    end

    res
  end

  def question_block
    render_validation_block
    render_question_title_with_ref_or_not
    render_context_and_answer_blocks

    if question.can_have_conditional_hints?
      render_info_about_branching_questions
    end
  end

  def render_question_title_with_ref_or_not
    if question.delegate_obj.ref.present? || question.delegate_obj.sub_ref.present?
      render_question_with_ref
    else
      render_question_without_ref
    end
  end

  def render_context_and_answer_blocks
    form_pdf.indent 25.mm do
      render_question_context

      if question.classes != "regular-question" ||
         question_block_type(question) == "block" ||
         humanized_answer.blank?
        question_answer(question, "block")
      end
    end
  end

  def render_question_with_ref
    ref = question.ref || question.sub_ref
    form_pdf.text_box "#{ref.delete(' ')}.",
                      style: :bold,
                      width: 20.mm,
                      at: [11.mm, form_pdf.cursor - 5.mm]

    if question.escaped_title.present?
      form_pdf.indent 25.mm do
        form_pdf.render_text question.escaped_title,
                             style: :bold
      end
    end
  end

  def render_question_without_ref
    if question.escaped_title.present?
      if question.classes == "regular-question"
        form_pdf.indent 25.mm do
          if question_block_type(question) == "inline" && humanized_answer.present?
            inline_question_text = question.escaped_title
            inline_question_text += ": "
            inline_question_text += ANSWER_FONT_START
            inline_question_text += question_answer(question, "inline")
            inline_question_text += ANSWER_FONT_END

            form_pdf.text inline_question_text,
                          inline_format: true
          else
            form_pdf.text "#{question.escaped_title}:"
          end
        end
      else
        form_pdf.indent 11.mm do
          form_pdf.render_text "#{question.escaped_title}",
                               style: :bold
        end
      end
    end
  end

  def render_question_context
    if question.context.present? && form_pdf.form_answer.urn.blank?
      context = question.escaped_context(true)

      if question.classes == "application-notice help-notice"
        form_pdf.image "#{Rails.root}/app/assets/images/icon-important-print.png",
                       at: [-10.mm, form_pdf.cursor - 3.5.mm],
                       width: 6.5.mm,
                       height: 6.5.mm
        form_pdf.render_text context,
                             style: :bold
      else
        form_pdf.render_text context
      end
    end
  end

  def render_validation_block
    # Valid/pending icon
    # TODO If it has validation
    if false
      # TODO If it is valid
      if false
        valid_icon = "icon-valid-pdf.png"
      else
        valid_icon = "icon-pending-pdf.png"
      end

      form_pdf.image "#{Rails.root}/app/assets/images/#{valid_icon}",
                     at: [0, form_pdf.cursor - 4.mm],
                     width: 7.mm
    end
  end

  def render_info_about_branching_questions
    if answer.blank? &&
      children_conditions.present? &&
      form_pdf.form_answer.urn.blank?

      form_pdf.indent 32.mm do
        children_conditions.each do |child_condition|
          render_option_branching_info(child_condition)
        end
      end
    end
  end

  def render_option_branching_info(child_condition)
    text = question.conditional_hint(child_condition, questions_with_references)
    form_pdf.render_text text,
                         color: "999999",
                         style: :italic,
                         size: 10
  end

  def question_block_type(question)
    unless FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      case question.delegate_obj
      when *BLOCK_QUESTIONS
        "block"
      else
        "inline"
      end
    end
  end

  def question_answer(question, display)
    unless FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      case question.delegate_obj
      when QAEFormBuilder::UploadQuestion
        form_pdf.indent 7.mm do
          render_attachments
        end
      when QAEFormBuilder::OptionsQuestion
        if humanized_answer.present?
          form_pdf.render_answer_by_display(question_option_title, display)
        else
          form_pdf.indent 7.mm do
            question.options.each do |answer|
              question_option_box answer.text
            end
          end
        end
      when QAEFormBuilder::ConfirmQuestion
        if humanized_answer.present?
          form_pdf.render_answer_by_display(question_checked_value_title, display)
        else
          question_option_box question.text
        end
      when QAEFormBuilder::ByYearsLabelQuestion
        form_pdf.indent 7.mm do
          render_years_labels_table
        end
      when QAEFormBuilder::ByYearsQuestion, QAEFormBuilder::TurnoverExportsCalculationQuestion
        render_years_table
      when QAEFormBuilder::QueenAwardHolderQuestion
        if humanized_answer.present?
          render_queen_award_holder
        end
      when QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
        if humanized_answer.present?
          render_subsidiaries_plants
        end
      when QAEFormBuilder::SupportersQuestion
        form_pdf.indent 7.mm do
          render_supporters
        end
      when QAEFormBuilder::TextareaQuestion
        title = humanized_answer.present? ? humanized_answer : FormPdf::UNDEFINED_TITLE

        form_pdf.default_bottom_margin
        render_word_limit

        form_pdf.render_standart_answer_block(title)
      when *LIST_TYPES
        form_pdf.indent 7.mm do
          render_list
        end
      else
        title = humanized_answer.present? ? humanized_answer : FormPdf::UNDEFINED_TITLE
        form_pdf.render_answer_by_display(title, display)
      end
    end
  end

  def render_queen_award_holder
    form_pdf.indent 7.mm do
      form_pdf.font("Times-Roman") do
        list_rows.each do |award|
          form_pdf.render_text "#{award[1]} - #{PREVIOUS_AWARDS[award[0].to_s]}",
                               color: "999999"
        end
      end
    end
  end

  def render_subsidiaries_plants
    form_pdf.indent 7.mm do
      list_rows.each do |subsidiary|
        subsidiary_text = subsidiary[0]
        subsidiary_text += ANSWER_FONT_START
        subsidiary_text += " in "
        subsidiary_text += subsidiary[1]
        subsidiary_text += " with "
        subsidiary_text += subsidiary[2]
        subsidiary_text += " employees"
        subsidiary_text += ANSWER_FONT_END

        form_pdf.render_text subsidiary_text,
                             inline_format: true
      end
    end
  end

  def render_word_limit
    if question.words_max.present? && form_pdf.form_answer.urn.blank?
      form_pdf.text "Word limit: #{question.words_max}"
      form_pdf.move_down 2.5.mm
    end
  end

  def render_attachments
    if humanized_answer.present?
      humanized_answer.each do |k, v|
        attachment_by_type(k, v)
      end
    else
      form_pdf.render_nothing_uploaded_message
    end
  end

  def attachment_by_type(_k, v)
    if v.keys.include?("file")
      attachment = form_pdf.form_answer_attachments.find(v["file"])
      form_pdf.draw_link_with_file_attachment(attachment, v["description"])
    elsif v.keys.include?("link")
      if v["link"].present?
        form_pdf.draw_link(v)
      end
    else
      fail UNDEFINED_TYPE
    end
  end

  def complex_question
    render_question_title_with_ref_or_not

    if question.delegate_obj.class.to_s == "QAEFormBuilder::HeadOfBusinessQuestion"
      form_pdf.move_up 5.mm
    end

    form_pdf.indent 25.mm do
      if sub_answers.length > 1
        sub_answers_by_type
      else
        first_sub_question = sub_answers[0][1]
        sub_question_block_without_title(first_sub_question)
      end
    end
  end

  def sub_answers_by_type
    case key.to_s
    when *FormPdf::TABLE_WITH_COMMENT_QUESTION
      render_table_with_optional_extra
    when *FormPdf::INLINE_DATE_QUESTION
      render_inline_date
    else
      render_sub_questions(sub_answers)
    end
  end

  def render_table_with_optional_extra
    cells = sub_answers.select do |a|
      a[0].match(/\/{1}[0-9]{2}\/{1}/).present? ||
      a[0].match(/Year/).present?
    end

    if cells.present?
      headers = cells.map { |a| a[0] }
      row = cells.map { |a| a[1] }
      render_single_row_table(headers, row)
    end

    comments = sub_answers - cells
    render_sub_questions(comments) if comments.present?
  end

  def render_single_row_table(headers, row)
    table_lines = [headers, row]
    form_pdf.render_table(table_lines)
  end

  def render_multirows_table(headers, rows)
    table_lines = rows.unshift(headers)
    form_pdf.render_table(table_lines)
  end

  def render_single_row_list(headers, row)
    form_pdf.indent 7.mm do
      headers.each_with_index do |_col, index|
        form_pdf.default_bottom_margin
        form_pdf.text "#{headers[index]}: #{ANSWER_FONT_START}#{row[index]}#{ANSWER_FONT_END}",
                      inline_format: true
      end
    end
  end

  def render_inline_date
    headers = sub_answers.map { |a| a[0] }
    row = sub_answers.map { |a| a[1] }
    row[1] = to_month(row[1]) if row[1].present?

    title = (row[0] == FormPdf::UNDEFINED_TITLE ? FormPdf::UNDEFINED_TITLE : row.join(" "))
    form_pdf.render_standart_answer_block(title)
  end

  def render_sub_questions(items)
    items.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer)
    end
  end

  def sub_question_block(sub_question, sub_answer)
    form_pdf.default_bottom_margin
    form_pdf.text "#{sub_question}: #{ANSWER_FONT_START}#{sub_answer}#{ANSWER_FONT_END}",
                  inline_format: true
  end

  def sub_question_block_without_title(sub_answer)
    form_pdf.font("Times-Roman") do
      form_pdf.render_text sub_answer,
                           color: "999999"
    end
  end

  def question_option_title
    question.options.select do |option|
      option.value.to_s == humanized_answer.to_s
    end.first.text
  end

  def question_option_box(title)
    form_pdf.default_bottom_margin

    # This adds some text so that we can be sure that the box and question text stay together between pages
    form_pdf.text "Test", color: "ffffff"
    form_pdf.move_up 4.5.mm

    form_pdf.bounding_box([0, form_pdf.cursor], width: 3.mm, height: 3.mm) do
      form_pdf.stroke_color "333333"
      form_pdf.stroke_bounds
    end

    form_pdf.move_up 3.mm

    form_pdf.indent 6.mm do
      form_pdf.text Nokogiri::HTML.parse(title).text
    end
  end

  def question_checked_value_title
    Nokogiri::HTML.parse(question.text).text.strip if humanized_answer == "on"
  end

  def to_month(value)
    Date::MONTHNAMES[value.to_i]
  end

  def get_audit_data(key)
    res = audit_data.detect do |d|
      d.keys.first.to_s == key.to_s
    end

    res.present? ? res[key.to_sym] : financial_empty_values
  end

  def financial_data(question_key, question_data)
    question_data.map do |entry|
      if entry.is_a?(Array)
        entry.join("/")
      else
        data_by_type(question_key, entry)
      end
    end
  end

  def data_by_type(question_key, entry)
    if entry[:value].present?
      if NOT_CURRENCY_QUESTION_KEYS.include?(question_key)
        entry[:value]
      else
        "£#{entry[:value]}" if entry[:value] != "-"
      end
    end
  end
end
