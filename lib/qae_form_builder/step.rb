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
