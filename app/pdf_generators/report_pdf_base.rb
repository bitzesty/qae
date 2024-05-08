require "prawn/measurement_extensions"

class ReportPdfBase < Prawn::Document
  include SharedPdfHelpers::DrawElements
  include SharedPdfHelpers::FontHelper
  include SharedPdfHelpers::LanguageHelper

  attr_reader :mode,
    :form_answer,
    :options,
    :pdf_doc,
    :missing_data_name,
    :award_year

  def initialize(mode, form_answer=nil, options={})
    super(page_size: "A4", page_layout: :landscape)

    @pdf_doc = self
    @mode = mode
    @form_answer = form_answer
    @options = options
    set_fonts!
    set_language!
    @award_year = if mode == "singular"
      form_answer.award_year
    else
      options[:award_year]
    end

    generate!
  end

  def generate!
    if mode == "singular"
      render_item(form_answer)
    else
      all_mode
    end
  end
end
