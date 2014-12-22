module ApplicationHelper
  def step_link_to(name, url, opts = {})
    opts[:class] ||= ""
    step_status = ""

    if opts[:index]
      if opts[:index_name]
        index_step_text = "<span class='step-number'>#{opts[:index_name]}</span> #{name}".html_safe
      else
        index_step_text = "<span class='step-number'>#{opts[:index]}.</span> #{name}".html_safe
      end
    else
      index_step_text = name
    end

    if opts[:index] && opts[:active]
      if opts[:index] == opts[:active]
        step_status  = "current"
        opts[:class] += " step-current"
      else
        if opts[:index] < opts[:active]
          step_status  = "past"
          opts[:class] += " step-past"
        end
      end
    end

    content_tag :li, opts do
      if step_status == "current" or (step_status != "past" && opts[:cant_access_future])
        content_tag :span do
          index_step_text
        end
      else
        link_to url do
          index_step_text
        end
      end
    end
  end

  def condition_divs(question, &block)
    inner = capture(&block)
    return inner if question.conditions.empty?

    current = inner
    for condition in question.conditions
      dep = question.form[condition.question_key]
      raise "Can't find parent question for conditional #{question.key} -> #{condition.question_key}" unless dep
      current = content_tag(:div, current, class: "js-conditional-question", data: {question: dep.parameterized_title, value: condition.question_value})
    end

    current
  end

end
