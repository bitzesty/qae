class QAEFormBuilder

  class ByTradeGoodsAndServicesLabelQuestionDecorator < QuestionDecorator
    def trade_goods_and_services
      @trade_goods_and_services ||= JSON.parse(answers[delegate_obj.key.to_s] || '[]').map do |answer|
        JSON.parse(answer)
      end
    end
  end

  class ByTradeGoodsAndServicesLabelQuestionBuilder < QuestionBuilder
    def rows num
      @q.rows = num
    end

    def words_max num
      @q.words_max = num
    end

    def min num
      @q.min = num
    end

    def max num
      @q.max = num
    end
  end

  class ByAmountCondition
    attr_accessor :question_key
    def initialize question_key
      @question_key = question_key
    end
  end

  class ByTradeGoodsAndServicesLabelQuestion < Question
    attr_accessor :rows, :words_max, :min, :max
  end
end
