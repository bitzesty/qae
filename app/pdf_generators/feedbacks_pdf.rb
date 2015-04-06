require "prawn/measurement_extensions"

class FeedbacksPdf < Prawn::Document
  include QaePdfForms::General::DrawElements

  UNDEFINED_TITLE = "Not answered yet..."

  attr_reader :user,
              :form_answer,
              :award_form

  def initialize(form_answer)
    super()

    @form_answer = form_answer
    @user = form_answer.user
    @award_form = form_answer.award_form.decorate

    generate!
  end

  def generate!
    main_header

    # TODO
  end
end
