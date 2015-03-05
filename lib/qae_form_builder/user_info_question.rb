class QAEFormBuilder
  class UserInfoQuestionDecorator < QuestionDecorator
    def required_sub_fields
      sub_fields
    end

    def rendering_sub_fields
      sub_fields.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class UserInfoQuestionBuilder < QuestionBuilder
    def sub_fields fields=[]
      @q.sub_fields = fields
    end
  end

  class UserInfoQuestion < Question
    attr_accessor :sub_fields
  end
end
