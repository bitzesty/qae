require 'active_support/inflector'

class QAEFormBuilder

  class StepDecorator < QAEDecorator

    def next
      @next ||= begin
        form.steps[index + 1]
      end
    end

    def previous
      @previous ||= begin
        form.steps[index-1] if index-1 >=0
      end
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

    def allowed_questions_params_list(form_data)
      Rails.logger.info "[questions] #{questions.map(&:key)}"

      allowed_params = {}

      questions.each do |q|
        allowed_params[q.key] = form_data[q.key]

        question_possible_sub_keys(q).each do |sub_question_key|
          allowed_params[sub_question_key] = form_data[sub_question_key]
        end
      end

      Rails.logger.info "[allowed_params before] #{allowed_params}"

      allowed_params = allowed_params.select do |k, v|
        v.present?
      end

      Rails.logger.info "[allowed_params after] #{allowed_params}"

      Rails.logger.info "[form_data] #{form_data.keys.count}"
      Rails.logger.info "[allowed_params] #{allowed_params.keys.count} #{allowed_params}"

      allowed_params
    end

    def question_possible_sub_keys(q)
      Rails.logger.info "[q] #{q.key}"

      question = q.decorate

      sub_question_keys = []
      sub_fields = question.sub_fields rescue nil
      required_sub_fields = question.required_sub_fields rescue nil
      by_year_conditions = question.by_year_conditions rescue nil

      Rails.logger.info "[sub_fields] #{sub_fields}"
      Rails.logger.info "[required_sub_fields] #{required_sub_fields}"
      Rails.logger.info "[by_year_conditions] #{by_year_conditions}"

      if sub_fields.present?
        res = sub_fields.map { |f| f.keys.first }
        Rails.logger.info "[sub_fields] res #{res}"
        sub_question_keys += res
      end

      if required_sub_fields.present?
        res = required_sub_fields.map { |f| f.keys.first }
        Rails.logger.info "[required_sub_fields] res #{res}"
        sub_question_keys += res
      end

      if by_year_conditions.present?
        res = question.by_year_conditions.map do |c|
          (1..c.years).map do |y|
            if q.is_a?(QAEFormBuilder::ByYearsLabelQuestion)
              [:day, :month, :year].map do |i|
                "#{y}of#{c.years}#{i}"
              end
            else
              "#{y}of#{c.years}"
            end
          end
        end.flatten
        Rails.logger.info "[by_year_conditions] res #{res}"

        sub_question_keys += res
      end

      sub_question_keys = sub_question_keys.flatten
                                            .uniq
                                            .map { |s| "#{question.key}_#{s}" }

      Rails.logger.info "[sub_question_keys] #{sub_question_keys}"
      sub_question_keys
    end

    private

    def count_questions meth
      questions.map{|q| q.send(meth) ? 1 : 0}.reduce(:+)
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
      klass_builder = QAEFormBuilder.const_get( "#{meth.to_s.camelize}QuestionBuilder" ) rescue nil
      klass = QAEFormBuilder.const_get( "#{meth.to_s.camelize}Question" ) rescue nil

      if klass_builder && klass && args.length >= 2 && args.length <=3
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

    attr_accessor :title, :short_title, :opts, :questions, :form, :context, :submit

    def initialize form, title, short_title, opts={}
      @form = form
      @title = title
      @short_title = short_title
      @opts = opts
      @questions = []
    end

    def decorate options = {}
      StepDecorator.new self, options
    end

  end
end
