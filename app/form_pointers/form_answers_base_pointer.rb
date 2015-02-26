module FormAnswersBasePointer
  HIDDEN_QUESTIONS = %w(agree_to_be_contacted contact_email_confirmation entry_confirmation)

  def fetch_answers
    ActiveSupport::HashWithIndifferentAccess.new(form_answer.document).select do |key, _value|
      !HIDDEN_QUESTIONS.include?(key.to_s)
    end
  end

  def fetch_filled_answers
    answers.reject do |_key, value|
      value.blank?
    end
  end

  def answers_by_key(_key)
    filled_answers.select do |key, _value|
      key.include?(key.to_s)
    end
  end

  def at_least_of_one_answer_by_key?(key)
    answers_by_key(key).any?
  end

  def fetch_answer_by_key(key)
    JSON.parse(answers[key])
  rescue
    answers[key]
  end

  def answer_based_on_type(key, value)
    if key.to_s.include?("country")
      ISO3166::Country.countries.select do |country|
        country[1] == value.strip
      end[0][0]
    else
      value
    end
  end
end