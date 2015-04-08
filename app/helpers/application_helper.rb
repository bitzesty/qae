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

  def landing_page?
    controller_name == 'content_only' && %w[home awards_for_organisations enterprise_promotion_awards how_to_apply timeline additional_information_and_contact terms apply_for_queens_award_for_enterprise].include?(action_name)
  end

  def application_deadline(kind)
    Settings.current.deadlines.where(kind: kind).first.decorate.formatted_trigger_time
  end

  def application_deadline_short(kind)
    Settings.current.deadlines.where(kind: kind).first.decorate.formatted_trigger_time_short
  end

  def format_date(date)
    date.strftime("%e %b %Y at %H:%M")
  end
end
