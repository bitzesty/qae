class QaePdfForms::General::QuestionPointer
  include QaePdfForms::CustomQuestions::ByYear
  include QaePdfForms::CustomQuestions::Lists

  attr_reader :form_pdf,
              :step,
              :question,
              :key,
              :answer,
              :humanized_answer,
              :sub_answers

  PREVIOUS_AWARDS = {"innovation_2" => "Innovation (2 years)",
                     "innovation_5" => "Innovation (5 years)",
                     "international_trade_3" => "International Trade (3 years)",
                     "international_trade_6" => "International Trade (6 years)",
                     "sustainable_development_2" => "Sustainable Development (2 years)",
                     "sustainable_development_5" => "Sustainable Development (5 years)" }

  def initialize(ops = {})
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

    if question.delegate_obj.class.to_s != "QAEFormBuilder::HeaderQuestion" || question.classes != "regular-question" || question.classes == "application-notice help-notice"
      form_pdf.move_down 5.mm
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
    if question.ref.present?
      form_pdf.text_box "#{question.ref.gsub(/\s+/, '')}.",
                           style: :bold,
                           width: 20.mm,
                           at: [11.mm, form_pdf.cursor - 5.mm]
      if question.title.present?
        form_pdf.indent 22.mm do
          form_pdf.render_text question.escaped_title,
                               style: :bold
        end
      end
    else
      if question.title.present?
        unless question.classes == "regular-question"
          form_pdf.indent 11.mm do
            form_pdf.render_text "#{question.escaped_title}",
                                 style: :bold
          end
        else
          form_pdf.indent 22.mm do
            if question_block_type(question) == "inline"
              form_pdf.text "#{question.escaped_title}: <font name='Times-Roman'><color rgb='999999'>#{question_answer(question, "inline")}</color></font>",
                            inline_format: true
            else
              form_pdf.text "#{question.escaped_title}:"
            end
          end
        end
      end
    end

    form_pdf.indent 22.mm do
      if question.context.present?
        unless question.classes == "application-notice help-notice"
          form_pdf.render_text question.escaped_context
        else
          form_pdf.image "#{Rails.root}/app/assets/images/icon-important-print.png",
                         at: [-10.mm, form_pdf.cursor - 3.5.mm],
                         width: 6.5.mm,
                         height: 6.5.mm
          form_pdf.render_text question.escaped_context,
                               style: :bold
        end
      end

      if question.classes != "regular-question" || question_block_type(question) == "block"
        question_answer(question, "block")
      end
    end
  end

  def question_block_type(question)
    unless FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      case question.delegate_obj
      when QAEFormBuilder::UploadQuestion
        return "block"
      when QAEFormBuilder::OptionsQuestion
        return "inline"
      when QAEFormBuilder::ConfirmQuestion
        return "inline"
      when QAEFormBuilder::ByYearsLabelQuestion
        return "block"
      when QAEFormBuilder::ByYearsQuestion
        return "block"
      when QAEFormBuilder::SupportersQuestion
        # TODO: NEED TO CONFIRM
      when QAEFormBuilder::TextareaQuestion
        return "block"
      when *LIST_TYPES
        return "block"
      else
        return "inline"
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
        title = humanized_answer.present? ? question_option_title : FormPdf::UNDEFINED_TITLE
        if display == "block"
          form_pdf.indent 7.mm do
            form_pdf.font("Times-Roman") do
              form_pdf.render_text title,
                                   color: "999999"
            end
          end
        else
          return title
        end
      when QAEFormBuilder::ConfirmQuestion
        title = humanized_answer.present? ? question_checked_value_title : FormPdf::UNDEFINED_TITLE
        if display == "block"
          form_pdf.indent 7.mm do
            form_pdf.font("Times-Roman") do
              form_pdf.render_text title,
                                   color: "999999"
            end
          end
        else
          return title
        end
      when QAEFormBuilder::ByYearsLabelQuestion
        form_pdf.indent 7.mm do
          render_years_labels_table
        end
      when QAEFormBuilder::ByYearsQuestion
        form_pdf.indent 7.mm do
          render_years_table
        end
      when QAEFormBuilder::QueenAwardHolderQuestion
        form_pdf.indent 7.mm do
          form_pdf.font("Times-Roman") do
            list_rows.each do |award|
              form_pdf.render_text "#{award[1]} - #{PREVIOUS_AWARDS[award[0].to_s]}",
                                   color: "999999"
            end
          end
        end
      when QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
        form_pdf.indent 7.mm do
          list_rows.each do |subsidiary|
            form_pdf.render_text "#{subsidiary[0]} <font name='Times-Roman'><color rgb='999999'>in #{subsidiary[1]} with #{subsidiary[2]} employees</color></font>",
                                 inline_format: true
          end
        end
      when QAEFormBuilder::SupportersQuestion
        # TODO: NEED TO CONFIRM
      when QAEFormBuilder::TextareaQuestion
        title = humanized_answer.present? ? humanized_answer : FormPdf::UNDEFINED_TITLE

        form_pdf.move_down 5.mm

        if question.words_max.present?
          form_pdf.text "Word limit: #{question.words_max}"

          form_pdf.move_down 2.5.mm

          form_pdf.indent 7.mm do
            form_pdf.font("Times-Roman") do
              form_pdf.text title,
                                   color: "999999"
            end
          end
        else
          form_pdf.indent 7.mm do
            form_pdf.font("Times-Roman") do
              form_pdf.text title,
                                   color: "999999"
            end
          end
        end
      when *LIST_TYPES
        form_pdf.indent 7.mm do
          render_list
        end
      else
        title = humanized_answer.present? ? humanized_answer : FormPdf::UNDEFINED_TITLE
        if display == "block"
          form_pdf.indent 7.mm do
            form_pdf.font("Times-Roman") do
              form_pdf.render_text title,
                                   color: "999999"
            end
          end
        else
          return title
        end
      end
    end
  end

  def render_attachments
    if humanized_answer.present?
      humanized_answer.each do |k, v|
        attachment_by_type(k, v)
      end
    else
      form_pdf.font("Times-Roman") do
        form_pdf.render_text FormPdf::UNDEFINED_TITLE,
                             color: "999999"
      end
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
    form_pdf.indent 11.mm do
      form_pdf.render_text question.escaped_title,
                           style: :bold
    end

    form_pdf.indent 22.mm do
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
      headers.each_with_index do |col, index|
        form_pdf.default_bottom_margin
        form_pdf.text "#{headers[index]}: <font name='Times-Roman'><color rgb='999999'>#{row[index]}</color></font>",
                      inline_format: true
      end
    end
  end

  def render_inline_date
    headers = sub_answers.map { |a| a[0] }
    row = sub_answers.map { |a| a[1] }
    row[1] = to_month(row[1]) if row[1].present?

    form_pdf.indent 7.mm do
      form_pdf.font("Times-Roman") do
        form_pdf.render_text row.join(" "),
                             color: "999999"
      end
    end
  end

  def render_sub_questions(items)
    items.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer)
    end
  end

  def sub_question_block(sub_question, sub_answer)
    form_pdf.default_bottom_margin
    form_pdf.text "#{sub_question}: <font name='Times-Roman'><color rgb='999999'>#{sub_answer}</color></font>",
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

  def question_checked_value_title
    Nokogiri::HTML.parse(question.text).text.strip if humanized_answer == "on"
  end

  def to_month(value)
    Date::MONTHNAMES[value.to_i]
  end
end
