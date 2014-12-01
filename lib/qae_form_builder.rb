require 'qae_form_builder/form'
require 'qae_form_builder/step'
require 'qae_form_builder/question'
require 'qae_form_builder/text_question'
require 'qae_form_builder/number_question'
require 'qae_form_builder/textarea_question'
require 'qae_form_builder/options_question'
require 'qae_form_builder/dropdown_question'
require 'qae_form_builder/date_question'
require 'qae_form_builder/upload_question'

require 'qae_form_builder/award_holder_question'
require 'qae_form_builder/previous_name_question'
require 'qae_form_builder/address_question'
require 'qae_form_builder/head_of_business_question'

class QAEFormBuilder
  class << self

    def build title, &block
      form = Form.new title
      form.instance_eval &block if block_given?
      form      
    end

  end
end
