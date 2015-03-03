module QaePdfForms::CustomQuestions::AwardLists
  def render_current_award_list
    headers = "AWARD_HOLDER_LIST_HEADERS"

    if humanized_answer.present?
      render_multirows_table(self.class.const_get(headers), award_rows)
    else
      form_pdf.render_text(FormPdf::UNDEFINED_TITLE, style: :italic)
    end
  end

  def queen_award_holder_query_conditions(prepared_item)
    if prepared_item["category"].present? && prepared_item["year"].present?
      [
        prepared_item["category"],
        prepared_item["year"]
      ]
    end
  end

  def award_holder_query_conditions(prepared_item)
    if prepared_item["title"].present?
      [
        prepared_item["title"],
        prepared_item["year"],
        prepared_item["details"]
      ]
    end
  end

  def award_rows
    humanized_answer.map do |item|
      prepared_item = JSON.parse(item)

      case question.delegate_obj
      when QAEFormBuilder::QueenAwardHolderQuestion
        headers = 'QUEENS_' + headers
        queen_award_holder_query_conditions(prepared_item)
      when QAEFormBuilder::AwardHolderQuestion
        award_holder_query_conditions(prepared_item)
      end
    end.compact
  end
end
