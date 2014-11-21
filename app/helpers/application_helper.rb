module ApplicationHelper
  def step_link_to(name, url, opts = {})
    opts[:class] ||= ""
    step_status = ""

    if opts.has_key?(:index)
      index_step_text = "<span class='step-number'>#{opts[:index]}.</span> #{name}".html_safe
    else
      index_step_text = name
    end

    if opts.has_key?(:index) && opts.has_key?(:active)
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
      if step_status == "current"
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
end
