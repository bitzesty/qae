class QuestionWordsValidator < ActiveModel::Validator
  def validate(record)
    field_name = options[:field_name]
    word_max = record.question.details_words_max
    str = record.send(field_name).split

    calculated_word_max = word_max.to_i + ten_percents(word_max) + 1

    return unless str.size > calculated_word_max

    record.errors[field_name] = "is too long (maximum is #{word_max} words)"
  end

  def ten_percents(word_max)
    ((word_max.to_f / 100.to_f) * 10.to_f).to_i
  end
end
