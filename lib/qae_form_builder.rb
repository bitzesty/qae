require 'qae_form_builder/form'
require 'qae_form_builder/step'
require 'qae_form_builder/question'

class QAEFormBuilder
  class << self

    def build &block
      form = Form.new
      form.instance_eval &block if block_given?
      form      
    end

  end
end
