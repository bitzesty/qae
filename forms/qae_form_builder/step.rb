require "active_support/inflector"

class QaeFormBuilder
  class StepDecorator < QaeDecorator
    QUESTIONS_WITH_NOT_REJECTING_BLANKS_ON_SAVE = %w(
      innovation_materials
      org_chart
    )

    def next
      @next ||= form.steps[index + 1]
    end

    def previous
      @previous ||= (form.steps[index - 1] if index - 1 >= 0)
    end

    def index
      @index ||= @decorator_options.fetch(:collection_idx)
    end

    def progress
      return 0 if required_visible_questions_total.zero?
      required_visible_questions_filled.to_f / required_visible_questions_total
    end

    def required_visible_questions_filled
      count_questions :required_visible_filled?
    end

    def required_visible_questions_total
      count_questions :required_visible?
    end

    def allowed_questions_params_list(form_data, document)
      allowed_params = {}
      form_data = form_data.dup.permit!
      questions.each do |question|
        allowed_params[question.key] = hashify_params(form_data[question.key])

        question_possible_sub_keys(question).each do |sub_question_key|
          allowed_params[sub_question_key] = if question.delegate_obj.is_a?(QaeFormBuilder::ByYearsQuestion) || question.delegate_obj.is_a?(QaeFormBuilder::OneOptionByYearsQuestion)
            # Sometimes users can input commas, we are stripping them
            form_data[sub_question_key].to_s.delete(",")
          else
            form_data[sub_question_key]
          end
        end

        if question.delegate_obj.is_a?(QaeFormBuilder::UploadQuestion) &&
            hashify_params(form_data[question.key]).nil?
          # This code handles case when user removes all attachments / links
          # from Form: Add Website Address/Documents section
          # As in this case params wouldn't have empty hash {}
          # And data for this question wouldn't be updated
          allowed_params[question.key] = {}
        end
      end

      allowed_params = allowed_params.select do |k, v|
        v.present? ||
          document[k.to_s].present? ||
          QUESTIONS_WITH_NOT_REJECTING_BLANKS_ON_SAVE.include?(k.to_s)
      end

      allowed_params
    end

    def hashify_params(params)
      params.is_a?(ActionController::Parameters) ? params.to_h : params
    end

    def question_possible_sub_keys(question)
      sub_question_keys = []

      sub_fields = question.sub_fields rescue nil
      required_sub_fields = question.required_sub_fields rescue nil
      by_year_conditions = question.by_year_conditions rescue nil

      if sub_fields.present?
        sub_question_keys += sub_fields.map { |f| f.keys.first }
      end

      if required_sub_fields.present?
        sub_question_keys += required_sub_fields.map { |f| f.keys.first }
      end

      if by_year_conditions.present?
        sub_question_keys += question.by_year_conditions.map do |c|
          (1..c.years).map do |y|
            if question.delegate_obj.is_a?(QaeFormBuilder::ByYearsLabelQuestion)
              [:day, :month, :year].map do |i|
                "#{y}of#{c.years}#{i}"
              end
            else
              "#{y}of#{c.years}"
            end
          end
        end.flatten
      end

      if question.delegate_obj.is_a?(QaeFormBuilder::MatrixQuestion)
        sub_question_keys += question.x_headings.map do |x_heading|
          question.y_headings.map do |y_heading|
            "#{x_heading.key}_#{y_heading.key}"
          end
        end.flatten
        sub_question_keys += question.x_headings.map do |x_heading|
          "#{x_heading.key}_total"
        end.flatten
      end

      if question.delegate_obj.is_a?(QaeFormBuilder::OneOptionByYearsLabelQuestion) || question.delegate_obj.is_a?(QaeFormBuilder::OneOptionByYearsQuestion)
        sub_question_keys += (1..3).map do |y|
          if question.delegate_obj.is_a?(QaeFormBuilder::OneOptionByYearsLabelQuestion)
            [:day, :month, :year].map do |i|
              "#{y}of3#{i}"
            end
          else
            "#{y}of3"
          end
        end.flatten
      end

      sub_question_keys.flatten
                       .uniq
                       .map { |s| "#{question.key}_#{s}" }
    end

    private

    def count_questions meth
      questions.map { |q| q.send(meth) ? 1 : 0 }.reduce(:+)
    end
  end

  class StepBuilder
    def initialize step
      @step = step
    end

    def context context
      @step.context = context
    end

    def submit text, &block
      s = StepSubmit.new text
      b = StepSubmitBuilder.new s
      b.instance_eval &block if block
      @step.submit = s
    end

    def method_missing(meth, *args, &block)
      klass_builder = QaeFormBuilder.const_get("#{meth.to_s.camelize}QuestionBuilder") rescue nil
      klass = QaeFormBuilder.const_get("#{meth.to_s.camelize}Question") rescue nil

      if klass_builder && klass && args.length >= 2 && args.length <= 3
        id, title, opts = args
        create_question klass_builder, klass, id, title, opts, &block
      else
        super
      end
    end

    private

    def create_question builder_klass, klass, id, title, opts={}, &block
      q = klass.new @step, id, title, opts
      b = builder_klass.new q
      b.instance_eval &block if block_given?
      @step.questions << q

      if q.respond_to?(:linkable?) && q.linkable?
        @step.sub_headers << q
      end

      raise ArgumentError, "Duplicate question key #{q.key}" if @step.form[q.key]
      @step.form.questions_by_key[q.key] = q
      q
    end
  end

  class StepSubmitBuilder
    def initialize submit
      @submit = submit
    end

    def notice notice
      @submit.notice = notice
    end

    def style style
      @submit.style = style
    end
  end

  class StepSubmit
    attr_accessor :notice, :style, :text

    def initialize text
      @text = text
    end
  end

  class Step
    attr_accessor :title, :short_title, :opts, :questions, :form, :context, :submit, :sub_headers

    def initialize form, title, short_title, opts={}
      @form = form
      @title = title
      @short_title = short_title
      @opts = opts
      @questions = []
      @sub_headers = []
    end

    def decorate options = {}
      StepDecorator.new self, options
    end
  end
end
