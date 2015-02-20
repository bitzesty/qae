class QaePdfForms::General::QuestionPointer
  include QaePdfForms::CustomQuestions::ByYear

  QUEENS_AWARD_HOLDER_LIST_HEADERS = [
    "Category", "Year Awarded"
  ]

  attr_reader :form_pdf,
              :step,
              :question,
              :key,
              :answer,
              :humanized_answer,
              :sub_answers

  def initialize(ops={})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @key = question.key
    @answer = answer_by_key
    @humanized_answer = form_pdf.answer_based_on_type(key, answer) if answer.present?
    @sub_answers = fetch_sub_answers
  end

  def render!
    if humanized_answer.present?
      question_block
    else
      sub_answers.any? ? complex_question : question_block
    end
  end

  def answer_by_key
    begin
      JSON.parse(form_pdf.answers[key])
    rescue
      form_pdf.answers[key]
    end
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
    form_pdf.render_text(question.escaped_title, {style: :bold})

    if !FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      case question.delegate_obj
      when QAEFormBuilder::UploadQuestion
        render_attachments
      when QAEFormBuilder::OptionsQuestion
        title = humanized_answer.present? ? question_option_title : FormPdf::UNDEFINED_TITLE
        form_pdf.render_text(title, {style: :italic})
      when QAEFormBuilder::ConfirmQuestion
        title = humanized_answer.present? ? question_checked_value_title : FormPdf::UNDEFINED_TITLE
        form_pdf.render_text(title, {style: :italic})
      when QAEFormBuilder::QueenAwardHolderQuestion, QAEFormBuilder::AwardHolderQuestion
        render_current_award_list
      when QAEFormBuilder::ByYearsLabelQuestion
        render_years_labels_table
      when QAEFormBuilder::ByYearsQuestion
        render_years_table
      else
        title = humanized_answer.present? ? humanized_answer : FormPdf::UNDEFINED_TITLE
        form_pdf.render_text(title, {style: :italic})
      end
    end
  end

  def render_current_award_list
    if humanized_answer.present?
      rows = humanized_answer.map do |item|
        prepared_item = JSON.parse(item)
        
        if prepared_item['category'].present? && prepared_item['year'].present?
          [
            prepared_item['category'], 
            prepared_item['year']
          ]
        end
      end.compact

      render_multirows_table(QUEENS_AWARD_HOLDER_LIST_HEADERS, rows)
    else
      form_pdf.render_text(FormPdf::UNDEFINED_TITLE, {style: :italic})
    end
  end

  def render_attachments
    if humanized_answer.present?
      humanized_answer.each do |k, v| 
        attachment_by_type(k, v)
      end
    else
      form_pdf.render_text(FormPdf::UNDEFINED_TITLE, {style: :italic})
    end
  end

  def attachment_by_type(k, v)
    if v.keys.include?('file')
      attachment = form_pdf.form_answer_attachments.find(v['file'])
      form_pdf.draw_link_with_file_attachment(attachment, v['description'])
    elsif v.keys.include?('link')
      form_pdf.draw_link(v)
    else
      raise UNDEFINED_TYPE
    end
  end

  def complex_question
    form_pdf.render_text(question.escaped_title, {style: :bold})

    if sub_answers.length > 1
      sub_answers_by_type
    else
      first_sub_question = sub_answers[0][1]
      sub_question_block_without_title(first_sub_question)
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

  def render_inline_date
    headers = sub_answers.map { |a| a[0] }
    row = sub_answers.map { |a| a[1] }
    row[1] = to_month(row[1]) if row[1].present?
    render_single_row_table(headers, row)
  end

  def render_sub_questions(items)
    items.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer)
    end
  end

  def sub_question_block(sub_question, sub_answer)
    form_pdf.render_text(sub_question, {style: :bold})
    form_pdf.render_text(sub_answer, {style: :italic})
  end

  def sub_question_block_without_title(sub_answer)
    form_pdf.render_text(sub_answer, {style: :italic})
  end

  def question_option_title
    question.options.select do |option| 
      option.value.to_s == humanized_answer.to_s
    end.first.text
  end

  def question_checked_value_title
    Nokogiri::HTML.parse(question.text).text.strip if humanized_answer == 'on'
  end

  def to_month(value)
    Date::MONTHNAMES[value.to_i]
  end
end