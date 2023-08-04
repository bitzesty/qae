require "qae_form_builder/qae_decorator"
require "qae_form_builder/qae_form"
require "qae_form_builder/step"
require "qae_form_builder/question"
require "qae_form_builder/multi_question_decorator"
require "qae_form_builder/multi_question_validator"

require "qae_form_builder/header_question"
require "qae_form_builder/about_section_question"
require "qae_form_builder/comment_question"
require "qae_form_builder/text_question"
require "qae_form_builder/number_question"
require "qae_form_builder/textarea_question"
require "qae_form_builder/options_question"
require "qae_form_builder/dropdown_question"
require "qae_form_builder/regions_question"
require "qae_form_builder/sic_code_dropdown_question"
require "qae_form_builder/date_question"
require "qae_form_builder/year_question"
require "qae_form_builder/upload_question"
require "qae_form_builder/options_business_name_changed_question"
require "qae_form_builder/mobility_application_category_options_question"
require "qae_form_builder/mobility_application_category_options_question_validator"
require "qae_form_builder/mobility_application_category_options_question_builder"

require "qae_form_builder/subsidiaries_associates_plants_question"
require "qae_form_builder/award_holder_question"
require "qae_form_builder/queen_award_holder_question"
require "qae_form_builder/queen_award_applications_question"
require "qae_form_builder/position_details_question"
require "qae_form_builder/previous_name_question"
require "qae_form_builder/country_question"
require "qae_form_builder/sub_fields_question"
require "qae_form_builder/address_question"
require "qae_form_builder/head_of_business_question"
require "qae_form_builder/press_contact_details_question"
require "qae_form_builder/user_info_question"

require "qae_form_builder/by_years_label_question"
require "qae_form_builder/by_years_question"
require "qae_form_builder/one_option_by_years_label_question"
require "qae_form_builder/one_option_by_years_question"
require "qae_form_builder/innovation_financial_year_date_question"
require "qae_form_builder/confirm_question"
require "qae_form_builder/checkbox_seria_question"
require "qae_form_builder/contact_email_question"
require "qae_form_builder/contact_question"
require "qae_form_builder/supporters_question"

require "qae_form_builder/by_trade_goods_and_services_label_question"
require "qae_form_builder/trade_commercial_success_question"
require "qae_form_builder/trade_most_recent_financial_year_options_question"

require "qae_form_builder/turnover_exports_calculation_question"

require "qae_form_builder/matrix_question"

class QaeFormBuilder
  class << self

    def build title, &block
      form = QaeForm.new title
      form.instance_eval &block if block_given?
      form
    end

  end
end
