module AppraisalFormHelper
  def render_section(form_answer, f)
    AppraisalForm.struct(form_answer, f).map do |k, section|
      section_obj = OpenStruct.new(section.merge(desc: "#{k}_desc", rate: "#{k}_rate"))
      partial = "admin/form_answers/appraisal_form_components/#{section[:type]}_section"

      render partial: partial, locals: { section: section_obj, f: f }
    end.join.html_safe
  end
end
