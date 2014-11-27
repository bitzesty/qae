class QAEFormBuilder
  class Form
    attr_reader :steps

    def initialize
      @steps = []
    end

    def step title, options = {}, &block
      step = Step.new title, options
      step.instance_eval &block if block_given?
      @steps << step
    end

  end
end
