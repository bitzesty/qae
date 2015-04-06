require "prawn/measurement_extensions"

class FeedbacksPdf < Prawn::Document
  include FeedbackPdfs::General::DrawElements
  include FeedbackPdfs::General::DataPointer

  UNDEFINED_VALUE = "Not filled yet..."

  attr_reader :user,
              :form_answer,
              :award_form,
              :feedback_data

  def initialize(form_answer)
    super(page_size: "A4", page_layout: :landscape)

    @form_answer = form_answer
    @user = form_answer.user
    @award_form = form_answer.award_form.decorate
    @feedback_data = form_answer.feedback.document

    generate!
  end

  def generate!
    main_header
    render_data!

    # TODO
  end
end
