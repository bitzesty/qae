module ApplicationHelper
  def step_link_to(name, url, opts = {})
    opts[:class] ||= ""
    step_status = ""

    if opts[:index]
      index_step_text = "<span class='step-number'>#{opts[:index]}.</span> #{name}".html_safe
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

  def question_for(question, opts = {}, &block)
    step = ""
    if opts[:step]
      step = content_tag :span, class: "steps", id: "step-#{opts[:step].to_s.parameterize}" do
        concat content_tag(:span, "Step #{opts[:step]}", class: "visuallyhidden") +
        content_tag(:span, "#{opts[:step]}", class: "todo")
      end
    end

    required = ""
    if opts[:required]
      required = content_tag(:abbr, "*")
    end

    help = ""
    if opts[:help]
      help = content_tag :div, class: "hidden-hint" do
        content_tag(:span, opts[:help][:title], class: "hidden-link") +
        content_tag(:span, opts[:help][:body].html_safe, class: "hidden-content")
      end
    end

    question_title = ""
    if question != ""
      question_title = content_tag :h2 do
        (step + question + required).html_safe
      end
    else
      if opts[:step]
        question_title = content_tag :h2 do
          step
        end
      end
    end

    question_context_text = ""
    if opts[:context_text]
      question_context_text = opts[:context_text].html_safe
    end

    question_body = content_tag :p, class: "group" do
      content_tag :label do
        question_hidden_title = content_tag :span, class: "visuallyhidden" do
          question + required
        end

        question_hidden_title + capture(&block)
      end
    end

    conditional_question = opts[:conditional] ? opts[:conditional][:question].parameterize : nil
    conditional_value = opts[:conditional] ? opts[:conditional][:value] : nil

    return content_tag :fieldset, class: "question-block js-conditional-answer #{'js-conditional-question' if opts[:conditional]}", data: {answer: question.parameterize, question: conditional_question, value: conditional_value } do
      (question_title + question_context_text + question_body + help).html_safe
    end
  end
end
