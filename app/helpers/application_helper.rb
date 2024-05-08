module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def step_link_to(name, url, opts = {})
    opts[:class] ||= "govuk-body"
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
        step_status = "current"
        opts[:class] += " step-current"
      else
        if opts[:disable_progression].present? && opts[:disable_progression]
          opts[:class] += " step-regular"
        elsif opts[:index] < opts[:active]
          step_status = "past"
          opts[:class] += " step-past"
        end
      end
    end

    content_tag :li, opts do
      if step_status == "current" or (step_status != "past" && opts[:cant_access_future])
        content_tag :span, class: "govuk-body" do
          index_step_text
        end
      else
        link_to url, class: "govuk-link" do
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

      data_attrs = {question: dep.parameterized_title, value: condition.question_value}
      data_attrs = data_attrs.merge((condition.options || {}).fetch(:data, {})) if condition.options

      current = content_tag(:div, current, class: "js-conditional-question", data: data_attrs)
    end

    current
  end

  def landing_page?
    controller_name == "content_only" && %w[
                                           home
                                           awards_for_organisations
                                           enterprise_promotion_awards
                                           how_to_apply
                                           timeline
                                           additional_information_and_contact
                                           apply_for_queens_award_for_enterprise
                                           privacy
                                         ].include?(action_name)
  end

  def show_navigation_links?
    current_user.present? && current_user.completed_registration? && current_user.account.has_collaborators?
  end

  def application_deadline(kind)
    deadline = Rails.cache.fetch("#{kind}_deadline", expires: 1.minute) do
      Settings.current.deadlines.where(kind: kind).first
    end

    deadline.decorate.formatted_trigger_time
  end

  def application_deadline_short(kind)
    deadline = Rails.cache.fetch("#{kind}_deadline", expires: 1.minute) do
      Settings.current.deadlines.where(kind: kind).first
    end

    deadline.decorate.formatted_trigger_time_short
  end

  def application_deadline_for_year(award_year, kind, format=nil)
    deadline = Rails.cache.fetch("#{kind}_deadline_#{award_year.year}", expires: 1.minute) do
      award_year.settings.deadlines.where(kind: kind).first
    end.decorate

    if format.present?
      deadline.formatted_trigger_date(format)
    else
      deadline.formatted_trigger_time_short
    end
  end

  def deadline_or_default(award_year, kind, manual_value, format=nil)
    str = application_deadline_for_year(award_year, kind, format)
    str.to_s.include?("---") ? manual_value : str
  end

  def format_date(date)
    date.strftime("%e %b %Y at %-l:%M%P")
  end

  # Custom version of http://apidock.com/rails/v4.2.1/ActionView/Helpers/TextHelper/simple_format
  # Because we do not need tag wrappers
  def qae_simple_format(text)
    text = sanitize(text)
    paragraphs = split_paragraphs(text)

    if paragraphs.present?
      paragraphs.map! { |paragraph|
        raw(paragraph)
      }.join("<br/><br/>").html_safe
    end
  end

  def ordinal(n)
    ending = case n % 100
           when 11, 12, 13 then "th"
           else
             case n % 10
             when 1 then "st"
             when 2 then "nd"
             when 3 then "rd"
             else "th"
             end
           end
    n.to_s + ending
  end

  def remove_html_tags(str)
    Nokogiri::HTML.parse(
      str,
    ).text.strip
  end

  def display_banner?
    subdomain_from_request.present? && subdomain_from_request.in?(["dev", "staging"])
  end

  def subdomain_from_request
    subdomain = request.subdomain.downcase
    parts = subdomain.split(".").reject { |part| part == "www" }
    parts.first
  end
end
