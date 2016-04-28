class QuestionWordsValidator < ActiveModel::Validator
  def validate(record)
    field_name = options[:field_name]
    word_max = record.question.details_words_max
    str = record.send(field_name).split

    if str.size > word_max
      record.errors[field_name] = "is too long (maximum is #{word_max} words)"
    end
  end
end
