class QAEFormBuilder

  class QuestionDecorator < QAEDecorator
    def input_name options = {}
      "#{form_name}[#{hash_key(options)}]"
    end

    def input_value options = {}
      answers[hash_key(options)]
    end

    def answers
      @decorator_options.fetch(:answers)
    end

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def hash_key options = {}
      options[:suffix] ? "#{delegate_obj.key}_#{options[:suffix]}" : delegate_obj.key
    end

    def fieldset_classes
      result = ["question-block",
       "js-conditional-answer"]
      result << delegate_obj.classes if delegate_obj.classes
      result << 'question-required' if delegate_obj.required
      result << 'js-conditional-drop-answer' if delegate_obj.drop_condition
      result
    end

    def fieldset_data_hash
      result = {answer: delegate_obj.parameterized_title}
      result['drop-question'] = delegate_obj.form[delegate_obj.drop_condition].parameterized_title if delegate_obj.drop_condition
      result
    end

  end

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def context text
      @q.context = text
    end

    def classes text
      @q.classes = text
    end

    def ref id
      @q.ref = id
    end

    def required
      @q.required = true
    end

    def help title, text
      @q.help << QuestionHelp.new(title, text)
    end

    def conditional key, value
      @q.conditions << QuestionCondition.new(key, value)
    end

    def drop_conditional key
      @q.drop_condition = key.to_s.to_sym
    end

    def header header
      @q.header = header
    end

    def header_context header_context
      @q.header_context = header_context
    end
  end

  QuestionCondition = Struct.new(:question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :step, :key,  :title, :context, :opts,
      :required, :help, :ref, :conditions, :header, :header_context, :classes, :drop_condition

    def initialize step, key, title, opts={}
      @step = step
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
      @conditions = []
      self.after_create if self.respond_to?(:after_create)
    end

    def decorate options = {}
      QuestionDecorator.new self, options
    end


    def form
      step.form
    end

    def parameterized_title
      key.to_s + "-" + title.parameterize
    end

  end

end

