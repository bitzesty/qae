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
      @q.help = QuestionHelp.new(title, text)
    end
  end

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :key,  :title, :context, :opts,
      :required, :help, :ref

    def initialize key, title, opts={}
      @key = key
      @title = title
      @opts = opts
      @required = false
    end
  end

  # options

  QuestionAnswerOption = Struct.new(:value, :text) 

  class OptionsQuestionBuilder < QuestionBuilder

    def option value, text
      @q.options << QuestionAnswerOption.new(value, text)
    end

  end
  
  class OptionsQuestion < Question
    attr_reader :options

    def initialize key, title, opts={}
      super key, title, opts
      @options = []
    end
  end

  # text

  class TextQuestionBuilder < QuestionBuilder
  end

  class TextQuestion < Question
  end

end
    
