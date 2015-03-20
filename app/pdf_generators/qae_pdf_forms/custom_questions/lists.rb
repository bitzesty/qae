module QaePdfForms::CustomQuestions::Lists
  LIST_TYPES = [
    QAEFormBuilder::AwardHolderQuestion,
    QAEFormBuilder::QueenAwardHolderQuestion,
    QAEFormBuilder::PositionDetailsQuestion,
    QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
  ]
  AWARD_HOLDER_LIST_HEADERS = [
    "Award/Honour title",
    "Year",
    "Details"
  ]
  QUEENS_AWARD_HOLDER_LIST_HEADERS = [
    "Category",
    "Year Awarded"
  ]
  SUBSIDIARIES_ASSOCIATES_PLANTS_HEADERS = [
    "Name",
    "Location",
    "Employees"
  ]
  POSITION_LIST_HEADERS = [
    "Name",
    "Start Date",
    "End Date",
    "Ongoing",
    "Details"
  ]

  def render_list
    if humanized_answer.present?
      render_multirows_table(list_headers, list_rows)
    else
      form_pdf.render_text(FormPdf::UNDEFINED_TITLE, style: :italic)
    end
  end

  def list_headers
    case question.delegate_obj
    when QAEFormBuilder::AwardHolderQuestion
      AWARD_HOLDER_LIST_HEADERS
    when QAEFormBuilder::QueenAwardHolderQuestion
      QUEENS_AWARD_HOLDER_LIST_HEADERS
    when QAEFormBuilder::PositionDetailsQuestion
      POSITION_LIST_HEADERS
    when QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
      SUBSIDIARIES_ASSOCIATES_PLANTS_HEADERS
    else
      raise "[#{self.class.name}] Unrecognized list type!"
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

  def position_details_query_conditions(prepared_item)
    if prepared_item["name"].present?
      [
        prepared_item["name"],
        "#{prepared_item['start_month']}/#{prepared_item['start_year']}",
        "#{prepared_item['end_month']}/#{prepared_item['end_year']}",
        prepared_item["ongoing"].to_s == "1" ? "yes" : "no",
        prepared_item["details"].present? ? prepared_item["details"] : FormPdf::UNDEFINED_TITLE
      ]
    end
  end

  def subsidiaries_associates_plants_query_conditions(prepared_item)
    if prepared_item["name"].present?
      [
        prepared_item["name"],
        prepared_item["location"].present? ? prepared_item["location"] : FormPdf::UNDEFINED_TITLE,
        prepared_item["employees"].present? ? prepared_item["employees"] : FormPdf::UNDEFINED_TITLE
      ]
    end
  end

  def list_rows
    humanized_answer.map do |item|
      prepared_item = JSON.parse(item)

      case question.delegate_obj
      when QAEFormBuilder::AwardHolderQuestion
        award_holder_query_conditions(prepared_item)
      when QAEFormBuilder::QueenAwardHolderQuestion
        queen_award_holder_query_conditions(prepared_item)
      when QAEFormBuilder::PositionDetailsQuestion
        position_details_query_conditions(prepared_item)
      when QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
        subsidiaries_associates_plants_query_conditions(prepared_item)
      end
    end.compact
  end
end
