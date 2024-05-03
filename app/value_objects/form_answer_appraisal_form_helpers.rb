module FormAnswerAppraisalFormHelpers
  def primary_assessor_name
    discrepancies_source["primary_assessor_name"]
  end

  def primary_assessor_email
    discrepancies_source["primary_assessor_email"]
  end

  def primary_assessor_submitted_at
    discrepancies_source["primary_assessor_submitted_at"]
  end

  def secondary_assessor_name
    discrepancies_source["secondary_assessor_name"]
  end

  def secondary_assessor_email
    discrepancies_source["secondary_assessor_email"]
  end

  def secondary_assessor_submitted_at
    discrepancies_source["secondary_assessor_submitted_at"]
  end

  def discrepancies_between_primary_and_secondary_appraisals_details
    list = discrepancies_source["discrepancies"]
    total_number_of_keys = list.count

    list.map.with_index do |discrepancy, _index|
      "#{discrepancy[1]} (#{discrepancy[2]} - #{discrepancy[3]})"
    end.join(", ")
  end

  def discrepancies_source
    discrepancies_between_primary_and_secondary_appraisals
  end
end
