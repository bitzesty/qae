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
  end

  QuestionCondition = Struct.new(:question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :key,  :title, :context, :opts,
      :required, :help, :ref, :condition

    def initialize key, title, opts={}
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
    end
  end

end

