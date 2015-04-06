require "prawn/measurement_extensions"

class FeedbackPdfs::Pointer
  include FeedbackPdfs::General::DrawElements
  include FeedbackPdfs::General::DataPointer

  UNDEFINED_VALUE = "Not filled yet..."

  attr_reader :user,
              :form_answer,
              :award_form,
              :feedback_data,
              :pdf_doc

  def initialize(pdf_doc, form_answer)
    @pdf_doc = pdf_doc
    @form_answer = form_answer
    @user = form_answer.user
    @award_form = form_answer.award_form.decorate
    @feedback_data = form_answer.feedback.document

    render_data
  end

  def render_data
    main_header
    render_data!
  end
end
