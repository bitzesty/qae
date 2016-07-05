class FeedbackForm
  def self.fields
    keys = AppraisalForm::ALL_FORMS.map do |form|
      form.keys
    end.flatten

    keys = filtered_fields(keys).uniq

    ["overall_summary"] + keys.map { |k| ["#{k}_strength", "#{k}_weakness"] }.flatten + AppraisalForm::DEVELOPMENT.keys.map { |k| "#{k}_rate" }
  end

  def self.fields_for_award_type(type)
    keys = {}
    const_get("AppraisalForm::#{type.upcase}").each do |k, v|
      keys[k] = { label: v[:label], type: v[:type] }
    end

    filtered_fields(keys)
  end

  def self.filtered_fields(fields)
    fields.delete_if { |k| k == :verdict }
  end

  def self.strength_options_for(feedback, field)
    options = AppraisalForm::STRENGTH_OPTIONS

    option = options.detect do |opt|
      opt[1] == feedback.document["#{field}_rate"]
    end || ["Select Key Strengths and Focuses", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end
end
