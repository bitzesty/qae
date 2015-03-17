class FeedbackForm
  def self.fields
    keys = AppraisalForm::TRADE.keys + AppraisalForm::INNOVATION.keys
    keys += AppraisalForm::PROMOTION.keys + AppraisalForm::DEVELOPMENT.keys

    keys = filtered_fields(keys).uniq

    keys.map { |k| ["#{k}_strength", "#{k}_weakness"] }.flatten
  end

  def self.fields_for_award_type(type)
    keys = {}
    const_get("AppraisalForm::#{type.upcase}").each do |k, v|
      keys[k] = { label: v[:label] }
    end

    filtered_fields(keys)
  end

  def self.filtered_fields(fields)
    fields.delete_if { |k| k == :verdict }
  end
end
