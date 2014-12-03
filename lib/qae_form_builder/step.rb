class QAEFormBuilder

  class StepBuilder

    def initialize step
      @step = step
    end

    def context context
      @step.context = context
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

  class Step

    attr_accessor :title, :opts, :questions, :index, :form, :context

    def initialize form, title, opts={}
      @form = form
      @title = title
      @opts = opts
      @questions = []
    end

    def next
      # index 1-based
      @next ||= @form.steps[index]
    end

    def previous
      # index 1-based
      @previous ||= begin
        @form.steps[index-2] if index-2 >=0
      end
    end

  end
end 
