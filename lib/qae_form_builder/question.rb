class QAEFormBuilder
  class Question
    attr_accessor :key, :title, :options

    def initialize key, title, options={}
      @key = key
      @title = title
      @options = options
    end

  end
end
    
