module AppraisalFormHelper
  ENTRY_RELATES_TO_OPTIONS = [
    {"products" => "Products"},
    {"services" => "Services"},
    {"product" => "A product"},
    {"service" => "A service"},
    {"business_model" => "A business model"},
    {"management_approach" => "A management approach"},
    {"mentoring" => "A programme which provides careers advice, skills development or mentoring that prepare young people for the world of work and/or accessible structured work experience."},
    {"career_opportunities_accessibility" => "A programme which makes career opportunities more accessible by offering non-graduate routes such as traineeships, apprenticeships or internships, or by reforming recruitment practices."},
    {"workplace_fostering" => "A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers."},
  ]

  COMPANY_ORGANISATION_TYPES = [
    ["Company", "company"],
    ["Charity", "charity"],
  ]

  ENTRY_RELATES_TO_TRADE_OPS = ["products", "services"]
  ENTRY_RELATES_TO_INNOVATION_OPS = ["product", "service", "business_model"]
  ENTRY_RELATES_TO_DEVELOPMENT_OPS = ["product", "service", "management_approach"]
  ENTRY_RELATES_TO_MOBILITY_OPS = ["mentoring", "career_opportunities_accessibility", "workplace_fostering"]

  def options_available(options)
    @check_options = ENTRY_RELATES_TO_OPTIONS.select do |i|
      options.include?(i.keys.first)
    end.map do |el|
       [
          el.keys.first,
          el.values.first,
       ]
    end
  end

  def render_section(form_answer, f)
    section_odd_even = false
    AppraisalForm.struct(form_answer, f).map do |k, section|
      section_obj = OpenStruct.new(section.merge(desc: "#{k}_desc", rate: "#{k}_rate"))
      partial = "admin/form_answers/appraisal_form_components/#{section[:type]}_section"

      section_odd_even = !section_odd_even

      render partial: partial, locals: { section: section_obj, f: f, section_odd_even: section_odd_even }
    end.join.html_safe
  end
end
