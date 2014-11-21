module ApplicationHelper
  def step_link_to(name, url, opts = {})
    index_step_text = "<span class='step-number'>#{opts[:index]}.</span> #{name}".html_safe

    opts[:class] ||= ""

    if opts.has_key?(:index) && opts[:index].is_a?(Integer)
      if opts.has_key?(:active) && opts[:active].is_a?(Integer)
        if opts[:index] == opts[:active]
          opts[:class] += " step-current"

          content_tag :li, opts do
            content_tag :span do
              index_step_text
            end
          end
        else
          if opts[:index] < opts[:active]
            opts[:class] += " step-past"
          end

          content_tag :li, opts do
            link_to url do
              index_step_text
            end
          end
        end
      else
        content_tag :li, opts do
          link_to url do
            index_step_text
          end
        end
      end
    else
      content_tag :li, opts do
        link_to name, url
      end
    end
  end
end
