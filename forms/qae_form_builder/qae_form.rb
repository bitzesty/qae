class QaeFormBuilder
  class QaeForm
    attr_reader :title, :opts, :steps, :questions_by_key

    def initialize(title, opts = {})
      @title = title
      @opts = opts
      @steps = []

      @questions_by_key = {}
    end

    def [](key)
      @questions_by_key[key]
    end

    def decorate(options = {})
      QaeFormDecorator.new self, options
    end

    def step(title, short_title, options = {}, &)
      step = Step.new self, title, short_title, options

      builder = StepBuilder.new step
      builder.instance_eval(&) if block
      @steps << step
      step
    end
  end
end
