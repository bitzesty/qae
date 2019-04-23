module FormAnswerAppraisalFormHelpers
  def primary_assessor_name
    discrepancies_source["primary_assessor_name"]
  end

  def primary_assessor_email
    discrepancies_source["primary_assessor_email"]
  end

  def primary_assessor_submitted_at
    discrepancies_source["primary_assessor_submitted_at"].strftime("%e %b %Y at %-l:%M%P")
  end

  def secondary_assessor_name
    discrepancies_source["secondary_assessor_name"]
  end

  def secondary_assessor_email
    discrepancies_source["secondary_assessor_email"]
  end

  def secondary_assessor_submitted_at
    discrepancies_source["secondary_assessor_submitted_at"].strftime("%e %b %Y at %-l:%M%P")
  end

  def discrepancies_between_primary_and_secondary_appraisals_details
    list = discrepancies_source["discrepancies"]
    total_number_of_keys = list.count

    list.map.with_index do |discrepancy, index|
      line = "#{discrepancy[1]}: primary: #{discrepancy[2]} - secondary: #{discrepancy[3]}"
      line += "\n" if index + 1 < total_number_of_keys

      line
    end
  end

  def discrepancies_source
    discrepancies_between_primary_and_secondary_appraisals
  end
end