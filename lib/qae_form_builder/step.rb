class QAEFormBuilder

  class StepBuilder

    def initialize step
      @step = step
    end

    def method_missing(meth, *args, &block)
      klass_builder = QAEFormBuilder.const_get( "#{meth.capitalize}QuestionBuilder" ) rescue nil
      klass = QAEFormBuilder.const_get( "#{meth.capitalize}Question" ) rescue nil
      if klass_builder && klass && args.length >= 2 && args.length <=3 
        id, title, opts = args
        create_question klass_builder, klass, id, title, opts, &block 
      else
        super
      end
    end

    private

    def create_question builder_klass, klass, id, title, opts={}, &block
      q = klass.new id, title, opts
      b = builder_klass.new q
      b.instance_eval &block if block_given?
      @step.questions << q
      q
    end
  end

  class Step

    attr_accessor :title, :opts, :questions, :index

    def initialize title, opts={}
      @title = title
      @opts = opts
      @questions = []
    end

  end
end 
