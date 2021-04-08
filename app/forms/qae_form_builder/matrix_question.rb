class QAEFormBuilder
  class MatrixQuestionValidator < QuestionValidator
    # def errors
    #   result = super

    #   if question.required?
    #     question.required_sub_fields.each do |sub_field|
    #       suffix = sub_field.keys[0]
    #       if !question.input_value(suffix: suffix).present?
    #         result[question.hash_key(suffix: suffix)] ||= ""
    #         result[question.hash_key(suffix: suffix)] << " Can't be blank."
    #       end
    #     end
    #   end

    #   # need to add question-has-errors class
    #   result[question.hash_key] ||= "" if result.any?

    #   result
    # end
  end

  class MatrixQuestionDecorator < QuestionDecorator
  end

  class MatrixValue
    attr_reader :x, :y
    attr_accessor :value

    def initialize(x:, y:, value: nil)
      @x = x
      @y = y
      @value = value
    end
  end

  class MatrixHeading
    attr_reader :key, :label

    def initialize(key:, label:)
      @key = key
      @label = label
    end
  end

  class MatrixQuestionBuilder < QuestionBuilder
    def label label
      @q.label = label
    end

    def totals_label label
      @q.totals_label = label
    end

    def corner_label label
      @q.corner_label = label
    end

    def x_heading key, label
      @q.x_headings << MatrixHeading.new(key: key, label: label)
    end

    def y_heading key, label
      @q.y_headings << MatrixHeading.new(key: key, label: label)
    end

    def x_headings headings
      headings.each do |heading|
        if heading.is_a?(Array)
          x_heading *heading
        else
          x_heading heading.to_s.parameterize.underscore, heading
        end
      end
    end

    def y_headings headings
      headings.each do |heading|
        if heading.is_a?(Array)
          y_heading *heading
        else
          y_heading heading.to_s.parameterize.underscore, heading
        end
      end
    end
  end

  class MatrixQuestion < Question
    attr_accessor :label,
                  :totals_label,
                  :corner_label,
                  :x_headings,
                  :y_headings,
                  :values
                  
    def after_create
      @x_headings = []
      @y_headings = []
      @values = []
    end

    def classes
      "question-matrix"
    end
  end

end
