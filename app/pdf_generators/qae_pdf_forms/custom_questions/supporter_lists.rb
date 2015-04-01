module QaePdfForms::CustomQuestions::SupporterLists
  def render_supporters
    entries = if question.list_type == :manuall_upload
      form_answer.support_letters.manual
    else
      form_answer.supporters
    end

    if entries.present?
      render_supporters_list(entries)
    else
      form_pdf.font("Times-Roman") do
        form_pdf.render_text "Nothing uploaded yet...",
                             color: "999999"
      end
    end
  end

  def render_supporters_list(entries)
    entries.each do |entry|
      ops = {
        full_name: "#{entry.first_name} #{entry.last_name}",
        relationship_to_nominee: entry.relationship_to_nominee
      }

      if entry.is_a?(Supporter)
        ops[:email] = entry.email
      end

      render_supporter(entry, ops)
    end
  end

  def render_supporter(entry, ops)
    form_pdf.move_down 5.mm

    ops.each do |option_title, option_value|
      form_pdf.text "#{option_title.to_s.split("_").join(" ").capitalize}: ", style: :bold
      form_pdf.text option_value
      form_pdf.move_down 2.5.mm
    end
  end
end
