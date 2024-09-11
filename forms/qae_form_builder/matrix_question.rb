class QaeFormBuilder
  AUTO_CALCULATED_HEADINGS = %w[total_system_calculated calculated_total calculated_proportion calculated_sub_total].freeze
  EXCLUDED_HEADINGS = %w[calculated_sub_total others calculated_total calculated_proportion].freeze
  class MatrixQuestionValidator < QuestionValidator
    def errors
      result = super
      if question.required?
        question.y_headings.each do |y_heading|
          question.x_headings.each do |x_heading|
            suffix = "#{x_heading.key}_#{y_heading.key}"
            if !AUTO_CALCULATED_HEADINGS.any? { |excluded| question.input_name(suffix: suffix).include?(excluded) }
              if question.input_value(suffix: suffix).blank?
                if (question.required_row_parent && question.required_rows.include?(y_heading.key)) || !question.required_row_parent
                  result[question.hash_key(suffix: suffix)] ||= ""
                  result[question.hash_key(suffix: suffix)] << "Must be filled in. Enter '0' if none"
                end
              elsif !/\A\d+\z/.match(question.input_value(suffix: suffix).to_s)
                result[question.hash_key(suffix: suffix)] ||= ""
                result[question.hash_key(suffix: suffix)] << "Must be a whole number"
              end
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
        delegate_obj.required_rows = []

        step.form[delegate_obj.required_row_parent].input_value&.each { |a| delegate_obj.required_rows << a["type"] }
      end

      errors
    end

    def calculate_row_total(question_key, x_headings, y_headings, answers)
      row_totals = {}

      y_headings.each do |y_heading|
        row_totals[y_heading.key] ||= 0
        x_headings.each do |x_heading|
          cell_value = answers["#{question_key}_#{x_heading.key}_#{y_heading.key}"]
          unless x_heading.key == "total_system_calculated"
            row_totals[y_heading.key] += cell_value.to_i
          end
          answers["#{question_key}_total_system_calculated_#{y_heading.key}"] = row_totals[y_heading.key]
        end
      end
    end

    def calculate_col_total(question_key, x_headings, y_headings, answers)
      col_totals = {}

      x_headings.each do |x_heading|
        col_totals[x_heading.key] ||= 0
        if y_headings.any? { |heading| heading.key == "calculated_sub_total" }
          subtotal = answers["#{question_key}_#{x_heading.key}_calculated_sub_total"].to_i
          others = answers["#{question_key}_#{x_heading.key}_others"].to_i
          total = subtotal + others
          answers["#{question_key}_#{x_heading.key}_calculated_total"] = total
        else
          y_headings.each do |y_heading|
            cell_value = answers["#{question_key}_#{x_heading.key}_#{y_heading.key}"]
            unless y_heading.key == "calculated_total" || y_heading.key == "calculated_proportion"
              col_totals[x_heading.key] += cell_value.to_i
            end
            answers["#{question_key}_#{x_heading.key}_calculated_total"] = col_totals[x_heading.key]
          end
        end
      end
    end

    def calculate_col_subtotal(question_key, x_headings, y_headings, answers)
      col_subtotals = {}

      x_headings.each do |x_heading|
        col_subtotals[x_heading.key] ||= 0
        y_headings.each do |y_heading|
          cell_value = answers["#{question_key}_#{x_heading.key}_#{y_heading.key}"]
          unless EXCLUDED_HEADINGS.include?(y_heading.key)
            col_subtotals[x_heading.key] += cell_value.to_i
          end
          answers["#{question_key}_#{x_heading.key}_calculated_sub_total"] = col_subtotals[x_heading.key]
        end
      end
    end

    def calculate_proportion(question_key, answers, x_heading, y_heading)
      disadvantaged = if y_headings.any? { |heading| heading.key == "calculated_sub_total" }
        answers["#{question_key}_#{x_heading}_calculated_sub_total"].to_f
      else
        answers["#{question_key}_#{x_heading}_total_disadvantaged"].to_f
      end
      disadvantaged ||= 0
      total = answers["#{question_key}_#{x_heading}_calculated_total"].to_f
      proportion = (disadvantaged.to_f / total * 100).round(2)
      answers["#{question_key}_#{x_heading}_calculated_proportion"] = proportion.nan? ? 0 : proportion
    end

    def assign_autocalculated_value(question_key, x_headings, y_headings, answers, disabled_input, x_heading, y_heading)
      case disabled_input
      when "auto-totals-col"
        calculate_row_total(question_key, x_headings, y_headings, answers)
      when "auto-totals-row"
        calculate_col_total(question_key, x_headings, y_headings, answers)
      when "auto-subtotals-row"
        calculate_col_subtotal(question_key, x_headings, y_headings, answers)
      when "auto-proportion-row"
        calculate_proportion(question_key, answers, x_heading, y_heading)
      end
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
    attr_reader :key, :label, :options

    def initialize(key:, label:, options: {})
      @key = key
      @label = label
      @options = options
    end
  end

  class MatrixQuestionBuilder < QuestionBuilder
    def label label
      @q.label = label
    end

    def others_label label
      @q.others_label = label
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

    def auto_totals_column auto_totals_column
      @q.auto_totals_column = auto_totals_column
    end

    def x_heading key, label
      @q.x_headings << MatrixHeading.new(key: key, label: label)
    end

    def y_heading key, label, options = {}
      @q.y_headings << MatrixHeading.new(key: key, label: label, options: options)
    end

    def x_headings headings
      headings.each do |heading|
        if heading.is_a?(Array)
          x_heading(*heading)
        else
          x_heading heading.to_s.parameterize.underscore, heading
        end
      end
    end

    def y_headings headings
      headings.each do |heading|
        if heading.is_a?(Array)
          y_heading(*heading)
        else
          y_heading heading.to_s.parameterize.underscore, heading
        end
      end
      if @q.subtotals_label
        y_heading "calculated_sub_total", @q.subtotals_label, { row_class: "auto-subtotals-row" }
      end
      if @q.others_label
        y_heading "others", @q.others_label, { row_class: "others-not-disadvantaged-row" }
      end
      if @q.totals_label
        y_heading "calculated_total", @q.totals_label, { row_class: "auto-totals-row" }
      end
      if @q.proportion_label
        y_heading "calculated_proportion", @q.proportion_label, { row_class: "auto-proportion-row" }
      end
    end

    def column_widths widths
      @q.column_widths = widths
    end

    def required_rows question_key, **opts
      @q.required_row_parent = question_key
      @q.required_row_options = opts
    end
  end

  class MatrixQuestion < Question
    attr_accessor :label,
      :others_label,
      :subtotals_label,
      :totals_label,
      :proportion_label,
      :corner_label,
      :x_headings,
      :y_headings,
      :values,
      :column_widths,
      :required_row_parent,
      :required_row_options,
      :required_rows,
      :auto_totals_column

    def after_create
      @x_headings = []
      @y_headings = []
      @values = []
      @column_widths = nil
      @required_row_parent = nil
      @required_row_options = Hash[]
      @required_rows = []
    end

    def classes
      "question-matrix"
    end
  end
end
