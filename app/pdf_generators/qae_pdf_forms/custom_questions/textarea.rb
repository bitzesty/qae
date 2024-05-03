module QaePdfForms::CustomQuestions::Textarea
  LIST_TAGS = %w[ul ol].freeze

  MAIN_CONTENT_BLOCKS = (LIST_TAGS + %w[p]).freeze

  SUPPORTED_TAGS = MAIN_CONTENT_BLOCKS + %w[
    li a em strong text br
  ].freeze

  POSSIBLE_TEXT_ALIGN_VALUES = %i[left center right justify]

  def render_wysywyg_content
    return unless display_wysywyg_q?

    if this_is_wysywyg_content?
      wysywyg_entries.each do |child|
        t_name = wysywyg_get_tag_name(child)

        next unless MAIN_CONTENT_BLOCKS.include?(t_name)

        render_wysywyg_line(
          {
            "<" + t_name + ">" => {
              style: wysywyg_get_style(child),
              content: wysywyg_get_item_content(child),
            },
          },
        )
      end
    else
      form_pdf.render_standart_answer_block(humanized_answer)
    end
  end

  private

  def display_wysywyg_q?
    q_visible? && humanized_answer.present?
  end

  def this_is_wysywyg_content?
    SUPPORTED_TAGS.any? do |tag|
      ##
      # force humanized_answer to be a String
      humanized_answer.to_s.include?("<#{tag}")
    end
  end

  def wysywyg_entries
    Nokogiri::HTML.parse(
      humanized_answer,
    ).children[1]
     .children[0]
     .children
  end

  def wysywyg_get_tag_name(tag)
    tag.name
  end

  def render_wysywyg_line(line)
    tag_abbr = line.keys[0]

    if tag_abbr == "<p>"
      lines_style = styles_picker(wysywyg_get_style_values(line).split(", "))
      content = wysywyg_get_values_content(line).join("")
      content = content.gsub("<br>", "").gsub("</br>", "")
      print_pdf(content, lines_style)

    elsif wysywyg_list_leading_tag?(tag_abbr)
      wysywyg_print_lists(tag_abbr, line)
    end
  end

  def wysywyg_list_leading_tag?(tag_abbr)
    LIST_TAGS.include?(tag_abbr.gsub(/(<|>)/, ""))
  end

  def wysywyg_list_ending_tag?(tag_abbr)
    ["</ul>", "</ol>"].include?(tag_abbr)
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
        el.split(":").second.strip.gsub!("px", "").to_i / 2
      end.sum

      "margin-left:#{margin_left}px"
    else
      ""
    end
  end

  def wysywyg_prepare_list_content(line)
    content = wysywyg_get_values_content(line)

    content.map! do |el|
      element = el.delete!("\r").delete!("\n").delete!("\t") if el.include?("\r\n")
      el
    end.reject!(&:blank?)

    content << "\r\n\t"
    content
  end

  def wysywyg_list_content_generator(content, styles, key)
    @counter = 0
    @string = []
    @styles = Array.wrap(styles)
    @keys_history = [key]
    @ns_history = [@counter]
    @li_counter = 0

    content.each do |i|
      if wysywyg_is_it_tag?(i, "li")
        wysywyg_handle_li_tag(key, i)

      elsif wysywyg_is_it_tag?(i, "ul")
        wysywyg_handle_ul_tag(key, i)

      elsif wysywyg_is_it_tag?(i, "ol")
        wysywyg_handle_ol_tag(i)

      elsif wysywyg_list_ending_tag?(i)
        wysywyg_handle_list_ending_tag

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

  def wysywyg_handle_list_ending_tag
    @keys_history.pop
    @counter = @ns_history.last
    @ns_history.pop
  end

  def wysywyg_is_it_tag?(i, match_rule)
    i.is_a?(Hash) && i.keys[0] == "<#{match_rule}>"
  end

  def wysywyg_handle_li_tag(key, i)
    @counter += 1 if key == "<ol>"

    if @string.present?
      li_style = styles_picker(@styles)
      print_pdf(@string.join(""), li_style)

      if @li_counter > 1
        (@li_counter - 1).times do
          @styles.pop
        end
      end

      @li_counter = 0
      @string = []
    end

    marker_of_list(@string, key, @counter)

    return if wysywyg_get_style_values(i).blank?

    @styles << wysywyg_get_style_values(i)
  end

  def wysywyg_handle_ul_tag(key, i)
    li_style = styles_picker(@styles)
    print_pdf(@string.join(""), li_style)

    key = "<ul>"
    @keys_history << key
    @ns_history << @counter
    @string = []

    (@styles << wysywyg_get_style_values(i).presence) || "margin-left: 20px"
  end

  def wysywyg_handle_ol_tag(i)
    li_style = styles_picker(@styles)
    print_pdf(@string.join(""), li_style)

    @ns_history << @counter
    @counter = 0
    @string = []
    @keys_history << "<ol>"

    (@styles << wysywyg_get_style_values(i).presence) || "margin-left: 20px"
  end

  def marker_of_list(string, key, n)
    string << if key == "<ul>"
                "• "
              else
                "#{n}. "
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
        form_pdf.text "#{line}", lines_style if lines_style.present?
        form_pdf.move_down 2.mm
      end
    end
  end

  def styles_picker(style_options)
    style_options = style_options[0].split(";").map(&:strip) if style_options.to_s.include?(";")
    style_options = Array.wrap(style_options)

    styles = { inline_format: true,
               color: FormPdf::DEFAULT_ANSWER_COLOR }
    if style_options.present?
      margin_list = style_options.select do |el|
        el.include?("margin-left")
      end.map! do |el|
        el.split(":").second.strip.gsub!("px", "").to_i
      end

      styles[:indent_paragraphs] = margin_list.sum

      style_options.select do |el|
        el.include?("text-align")
      end.uniq.map! do |el|
        parsed_align_value = el.split(":")
                               .second
                               .strip
                               .to_sym

        styles[:align] = parsed_align_value if POSSIBLE_TEXT_ALIGN_VALUES.include?(parsed_align_value)
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
    return if tag.xpath("text()").blank?

    tag.xpath("text()").text
  end

  def wysywyg_get_item_content(child, content = [])
    if child.children.present?
      child.children.each do |baby|
        t_name = wysywyg_get_tag_name(baby)

        content << case t_name
                   when "ul", "ol", "li"
                     { "<" + t_name + ">" => { style: wysywyg_get_style(baby) } }
                   when "a"
                     "<u><link href=#{links_href(baby)}>"
                   when "text", "p"
                     baby.text
                   else
                     "<" + t_name + ">"
                   end

        next unless t_name != "text"

        wysywyg_get_item_content(baby, content) if t_name != "p"

        ending_tag = "</" + t_name + ">"

        ending_tag = "#{ending_tag}</u>" if t_name == "link"

        content << sanitize_content(ending_tag)
      end
    end

    content
  end

  def sanitize_content(content)
    content = Nokogiri::HTML(content)
    content.xpath("//@style")
           .remove

    content.children
           .css("body")
           .to_html
           .gsub("<body>", "")
           .gsub("</body>", "")
  end
end
