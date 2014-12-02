class QAEFormBuilder

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def context text
      @q.context = text
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
      @q.condition = QuestionCondition.new key, value
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
    attr_accessor :key,  :title, :context, :opts,
      :required, :help, :ref, :condition, :header, :header_context

    def initialize key, title, opts={}
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
    end
  end

end

