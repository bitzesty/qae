class QAEFormBuilder

  class QAEFormDecorator < QAEDecorator

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def progress
      required_visible_questions_filled.to_f / required_visible_questions_total
    end

    def required_visible_questions_filled
      count_questions :required_visible_questions_filled
    end

    def required_visible_questions_total
      count_questions :required_visible_questions_total
    end

    private

    def count_questions meth
      steps.map{|step| step.send meth}.reduce(:+)
    end

  end

  class QAEForm
    attr_reader :title, :opts, :steps, :questions_by_key

    def initialize title, opts={}
      @title = title
      @opts = opts
      @steps = []

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

      builder = StepBuilder.new step
      builder.instance_eval &block if block_given?
      @steps << step
      step
    end

  end
end
