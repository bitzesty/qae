class FeedbackPdfs::Base < Prawn::Document
  attr_reader :mode,
              :form_answer,
              :feedbacks

  def initialize(mode, form_answer=nil)
    super(page_size: "A4", page_layout: :landscape)

    @mode = mode
    @form_answer = form_answer
    @feedbacks = Feedback.submitted if mode == "all"

    generate!
  end

  def generate!
    if mode == "singular"
      render_item(form_answer)
    else
      feedbacks.each_with_index do |feedback, index|
        start_new_page if index.to_i != 0
        render_item(feedback.form_answer)
      end
    end
  end

  def render_item(form_answer)
    FeedbackPdfs::Pointer.new(self, form_answer)
  end
end
