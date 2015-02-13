# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def promotion_step4
      @promotion_step4 ||= Proc.new {
        supporters :supporters, 'Waiting for wireframes' do
          ref 'D 1'
          limit 4
        end
      }
    end
  end
end
