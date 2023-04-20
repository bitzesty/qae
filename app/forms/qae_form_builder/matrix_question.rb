class QAEFormBuilder
  class MatrixQuestionValidator < QuestionValidator
    def errors
      result = super

      if question.required?
        question.y_headings.each do |y_heading|
          question.x_headings.each do |x_heading|
            suffix = "#{x_heading.key}_#{y_heading.key}"

            if !question.input_value(suffix: suffix).present? && question.required_rows.include?(y_heading.key)
              result[question.hash_key(suffix: suffix)] ||= ""
              result[question.hash_key(suffix: suffix)] << "Required"
            end
          end
        end
      end

      # need to add govuk-form-group--errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class MatrixQuestionDecorator < QuestionDecorator
    def required?
      errors = super

      if delegate_obj.required_row_parent
        step.form[delegate_obj.required_row_parent].input_value&.each {|a| delegate_obj.required_rows << a["type"] }
      end

      errors
    end
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

    def subtotals_label label
      @q.subtotals_label = label
    end

    def totals_label label
      @q.totals_label = label
    end

    def proportion_label label
      @q.proportion_label = label
    end

    def corner_label label
      @q.corner_label = label
    end

    def no_total_row no_total_row
      @q.no_total_row = no_total_row
    end

    def auto_totals_column auto_totals_column
      @q.auto_totals_column = auto_totals_column
    end

    def auto_subtotals_row auto_subtotals_row
      @q.auto_subtotals_row = auto_subtotals_row
    end

    def auto_totals_row auto_totals_row
      @q.auto_totals_row = auto_totals_row
    end

    def auto_proportion_row auto_proportion_row
      @q.auto_proportion_row = auto_proportion_row
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

    def column_widths widths
      @q.column_widths = widths
    end

    def required_rows question_key
      @q.required_row_parent = question_key
    end
  end

  class MatrixQuestion < Question
    attr_accessor :label,
                  :subtotals_label,
                  :totals_label,
                  :proportion_label,
                  :corner_label,
                  :x_headings,
                  :y_headings,
                  :values,
                  :column_widths,
                  :required_row_parent,
                  :required_rows,
                  :no_total_row,
                  :auto_totals_column,
                  :auto_subtotals_row,
                  :auto_totals_row,
                  :auto_proportion_row

    def after_create
      @x_headings = []
      @y_headings = []
      @values = []
      @column_widths = nil
      @required_row_parent = nil
      @required_rows = []
    end

    def classes
      "question-matrix"
    end
  end

end
