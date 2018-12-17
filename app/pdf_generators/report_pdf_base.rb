require "prawn/measurement_extensions"

class ReportPdfBase < Prawn::Document
  include SharedPdfHelpers::DrawElements

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
    set_font!
    @award_year = if mode == "singular"
      form_answer.award_year
    else
      options[:award_year]
    end

    generate!
  end

  def set_font!
    @pdf_doc.font_families.update( "Helvetica" => { normal: Rails.root.join('app', 'assets/fonts', 'Helvetica_Neue_W01_66_Medium_It.ttf').to_s, bold: Rails.root.join('app', 'assets/fonts', 'Helvetica_Neue_W01_66_Medium_It.ttf').to_s, italic: Rails.root.join('app', 'assets/fonts', 'Helvetica_Neue_W01_66_Medium_It.ttf').to_s, bold_italic: Rails.root.join('app', 'assets/fonts', 'Helvetica_Neue_W01_66_Medium_It.ttf').to_s } )
  end

  def generate!
    if mode == "singular"
      render_item(form_answer)
    else
      all_mode
    end
  end
end
