require 'qae_form_builder/qae_form'
require 'qae_form_builder/step'
require 'qae_form_builder/question'

require 'qae_form_builder/header_question'
require 'qae_form_builder/text_question'
require 'qae_form_builder/number_question'
require 'qae_form_builder/textarea_question'
require 'qae_form_builder/options_question'
require 'qae_form_builder/dropdown_question'
require 'qae_form_builder/date_question'
require 'qae_form_builder/upload_question'

require 'qae_form_builder/subsidiaries_associates_plants_question'
require 'qae_form_builder/award_holder_question'
require 'qae_form_builder/previous_name_question'
require 'qae_form_builder/address_question'
require 'qae_form_builder/head_of_business_question'

require 'qae_form_builder/innovation_by_years_question'
require 'qae_form_builder/trade_by_years_question'
require 'qae_form_builder/materials_question'
require 'qae_form_builder/confirm_question'
require 'qae_form_builder/contact_email_question'
require 'qae_form_builder/contact_question'

class QAEFormBuilder
  class << self

    def build title, &block
      form = QAEForm.new title
      form.instance_eval &block if block_given?
      form
    end

  end
end
