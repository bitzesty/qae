require "prawn/measurement_extensions"

class FeedbackPdfs::Base < Prawn::Document
  include FeedbackPdfs::General::DrawElements

  attr_reader :mode,
              :form_answer,
              :feedbacks,
              :options,
              :pdf_doc

  def initialize(mode, form_answer=nil, options={})
    super(page_size: "A4", page_layout: :landscape)

    @pdf_doc = self
    @mode = mode
    @form_answer = form_answer
    @options = options
    set_feedbacks if mode == "all"

    generate!
  end

  def generate!
    if mode == "singular"
      render_item(form_answer)
    else
      all_mode
    end
  end

  def all_mode
    if feedbacks.present?
      feedbacks.each_with_index do |feedback, index|
        start_new_page if index.to_i != 0
        render_item(feedback.form_answer)
      end
    else
      render_not_found_block
    end
  end

  def set_feedbacks
    @feedbacks = Feedback.submitted
                         .includes(:form_answer)
                         .where("form_answers.award_type = ?", options[:category])
                         .order("form_answers.award_year")
  end

  def render_item(form_answer)
    FeedbackPdfs::Pointer.new(self, form_answer)
  end
end
