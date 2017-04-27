module QaePdfForms::CustomQuestions::Textarea

  LIST_TAGS = ["ul", "ol"]

  MAIN_CONTENT_BLOCKS = ["p"] + LIST_TAGS

  SUPPORTED_TAGS = MAIN_CONTENT_BLOCKS + ["li", "a", "em", "strong", "text"]

  def render_wysywyg_content
    if display_wysywyg_q?
      wysywyg_entries.each do |child|
        t_name = wysywyg_get_tag_name(child)

        if MAIN_CONTENT_BLOCKS.include?(t_name)
          render_wysywyg_line(
            {
              "<" + t_name + ">" => {
                style: wysywyg_get_style(child),
                content: wysywyg_get_item_content(child)
              }
            }
          )
        end
      end
    end
  end

  private

  def display_wysywyg_q?
    q_visible? && humanized_answer.present?
  end

  def wysywyg_entries
    Nokogiri::HTML.parse(
      humanized_answer
    ).children[1]
     .children[0]
     .children
  end

  def wysywyg_get_tag_name(tag)
    tag.name if SUPPORTED_TAGS.include?(tag.name.to_s)
  end

  def render_wysywyg_line(line)
    tag_abbr = line.keys[0]

    if tag_abbr == "<p>"
      lines_style = styles_picker(wysywyg_get_style_values(line).split(", "))
      print_pdf(wysywyg_get_values_content(line).join(""), lines_style)

    elsif wysywyg_list_leading_tag?(tag_abbr)
      wysywyg_print_lists(tag_abbr, line)
    end
  end

  def wysywyg_list_leading_tag?(tag_abbr)
    LIST_TAGS.include?(tag_abbr.gsub(/(\<|\>)/, ""))
  end

  def wysywyg_list_ending_tag?(tag_abbr)
    tag_abbr == "</ul>" || tag_abbr == "</ol>"
  end

  def wysywyg_print_lists(key, line)
    wysywyg_list_content_generator(wysywyg_prepare_list_content(line),
                                   wysywyg_get_list_left_margin(line),
                                   key)
  end

  def wysywyg_get_list_left_margin(line)
    lists_style = wysywyg_get_style_values(line)

    if lists_style.present?
      margin_left = lists_style.split(", ").select do |el|
        el.include?("margin-left")
      end.map! do |el|
        el.split(":").second.strip.gsub!("px", "").to_i/2
      end.sum

      "margin-left:#{margin_left}px"
    else
      ""
    end
  end

  def wysywyg_prepare_list_content(line)
    content = wysywyg_get_values_content(line)

    content.map! do |el|
      if el.include?("\r\n")
        element = el.gsub!("\r", "").gsub!("\n", "").gsub!("\t", "")
      end
      el
    end.reject!(&:blank?)

    content << "\r\n\t"
    content
  end

  def wysywyg_list_content_generator(content, styles, key)
    @n = 0
    @string = []
    @styles = Array.wrap(styles)
    @keys_history = [key]
    @ns_history = [@n]
    @li_counter = 0

    content.each do |i|
      if wysywyg_is_it_tag?(i, 'li')
        wysywyg_handle_li_tag(key, i)

      elsif wysywyg_is_it_tag?(i, 'ul')
        wysywyg_handle_ul_tag(key, i)

      elsif wysywyg_is_it_tag?(i, 'ol')
        wysywyg_handle_ol_tag(key, i)

      elsif wysywyg_list_ending_tag?(i)
        wysywyg_handle_list_ending_tag(key, i)

      elsif i == "</li>"
        @li_counter += 1

      elsif i == content.last
        li_style = styles_picker(@styles)
        print_pdf(@string.join(""), li_style)

      else
        @string << i
      end
    end

    @string
  end

  def wysywyg_handle_list_ending_tag(key, i)
    @keys_history.pop
    @n = @ns_history.last
    @ns_history.pop
  end

  def wysywyg_is_it_tag?(i, match_rule)
    i.is_a?(Hash) && i.keys[0] == "<#{match_rule}>"
  end

  def wysywyg_handle_li_tag(key, i)
    if key == "<ol>"
      @n += 1
    end

    if @string.present?
      li_style = styles_picker(@styles)
      print_pdf(@string.join(""), li_style)

      if @li_counter > 1
        (@li_counter - 1).times do
          @styles.pop
        end

        @li_counter = 0
      else
        @li_counter = 0
      end

      @string = []
    end

    marker_of_list(@string, key, @n)

    if wysywyg_get_style_values(i).present?
      @styles << wysywyg_get_style_values(i)
    end
  end

  def wysywyg_handle_ul_tag(key, i)
    li_style = styles_picker(@styles)
    print_pdf(@string.join(""), li_style)

    key = "<ul>"
    @keys_history << key
    @ns_history << @n
    @string = []

    @styles << if wysywyg_get_style_values(i).present?
      wysywyg_get_style_values(i)
    else
      "margin-left: 20px"
    end
  end

  def wysywyg_handle_ol_tag(key, i)
    li_style = styles_picker(@styles)
    print_pdf(@string.join(""), li_style)

    @ns_history << @n
    @n = 0
    @string = []
    key = "<ol>"
    @keys_history << key

    @styles << if wysywyg_get_style_values(i).present?
      wysywyg_get_style_values(i)
    else
      "margin-left: 20px"
    end
  end

  def marker_of_list(string, key, n)
    if key == "<ul>"
      string << "• "
    else
      string << "#{n}. "
    end
  end

  def wysywyg_get_style_values(line)
    line.values[0][:style].to_s
  end

  def wysywyg_get_values_content(line)
    line.values[0][:content]
  end

  def print_pdf(line, lines_style)
    form_pdf.indent 7.mm do
      if line.present?
        form_pdf.font("Times-Roman") do
          form_pdf.text "#{line}", lines_style if lines_style.present?
          form_pdf.move_down 2.mm
        end
      end
    end
  end

  def styles_picker(arr)
    arr = Array.wrap(arr)

    styles = { inline_format: true,
                       color: FormPdf::DEFAULT_ANSWER_COLOR }
    if arr.present?
      margin_list = arr.select do |el|
        el.include?("margin-left")
      end.map! do |el|
        el.split(":").second.strip.gsub!("px", "").to_i
      end

      styles[:indent_paragraphs] = margin_list.sum

      arr.select do |el|
        el.include?("text-align")
      end.uniq.map! do |el|
        styles[:align] = el.split(":").second.strip.to_sym
      end
    end

    styles
  end

  def wysywyg_get_style(tag)
    get_attribute_value(tag, "style")
  end

  def links_href(tag)
    get_attribute_value(tag, "href")
  end

  def get_attribute_value(tag, attr_name)
    tag.attributes[attr_name].value if tag.attributes[attr_name].present?
  end

  def simple_text(tag)
    if tag.xpath('text()').present?
      tag.xpath('text()').text
    end
  end

  def wysywyg_get_item_content(child, content=[])
    if child.children.present?
      child.children.each do |baby|
        t_name = wysywyg_get_tag_name(baby)

        content << case t_name
        when "ul", "ol", "li"
          {"<" + t_name + ">" => {style: wysywyg_get_style(baby)}}
        when "a"
          "<u><link href=#{links_href(baby)}>"
        when "text"
          baby.text
        else
          "<" + t_name + ">"
        end

        wysywyg_get_item_content(baby, content)

        if t_name != "text"
          ending_tag = "</" + t_name + ">"

          if t_name == "link"
            ending_tag = "#{ending_tag}</u>"
          end

          content << ending_tag
        end
      end
    end

    content
  end
end
