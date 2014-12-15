class QAEFormBuilder

  class QAEFormDecorator < QAEDecorator

    def form_name
      @decorator_options[:form_name] || 'form'
    end

  end

  class QAEForm
    attr_reader :title, :opts, :steps, :questions_by_key

    def initialize title, opts={}
      @title = title
      @opts = opts
      @steps = []
      @index = 1

      @questions_by_key = {}
    end

    def [] key
      @questions_by_key[key]
    end

    def decorate options = {}
      QAEFormDecorator.new self, options
    end

    def step title, short_title, options = {}, &block
      step = Step.new self, title, short_title, options

      step.index = @index
      @index += 1

      builder = StepBuilder.new step
      builder.instance_eval &block if block_given?
      @steps << step
      step
    end

  end
end
