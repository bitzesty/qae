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
      feedbacks.each do |feedback|
        render_item(feedback.form_answer)
      end
    end
  end

  def render_item(form_answer)
    FeedbackPdfs::Pointer.new(self, form_answer).render_data
  end
end
