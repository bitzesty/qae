class Reports::PalaceAttendeePointer

  attr_reader :palace_attendee,
              :form_answer,
              :form_answer_pointer

  def initialize(palace_attendee)
    @palace_attendee = palace_attendee
    @form_answer = palace_attendee.palace_invite.form_answer
    @form_answer_pointer = Reports::FormAnswer.new(form_answer)
  end

  def call_method(methodname)
    return "not implemented" if methodname.blank?

    if respond_to?(methodname, true)
      send(methodname)
    elsif palace_attendee.respond_to?(methodname)
      palace_attendee.send(methodname)
    else
      "missing method"
    end
  end

  private

  def award_category
    form_answer_pointer.send(:category)
  end

  def organisation_company
    form_answer_pointer.send(:company_name)
  end

  def product_description
    form_answer_pointer.send(:product_service)
  end

  def previous_years_won
    form_answer_pointer.send(:current_queens_award_holder)
  end
end
