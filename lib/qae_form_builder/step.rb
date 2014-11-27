class QAEFormBuilder
  class Step

    attr_accessor :title, :options, :questions

    def initialize title, options = {}
      @title = title
      @options = options
      @questions = []
    end

    def question id, title, options={}, &block
      q = Question.new id, title, options
      q.instance_eval &block if block_given?
      @questions << q
    end

  end
end 
