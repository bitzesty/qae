module FormHelper
  def possible_read_only_ops(submission=nil)
    ops = {}

    if admin_in_read_only_mode? || (submission && !current_user.account_admin?)
      ops[:disabled] = "disabled"
      ops[:class] = "read-only"
    end

    ops
  end

  def show_award_tabs_for_assessor?
    # show tabs if lead is assigned to more than one category
    current_subject.categories_as_lead.size > 1
  end

  def next_step(form, step)
    return unless step

    steps = form.steps
    steps.map! { |s| s.title.parameterize }

    index = steps.index(step)

    steps[index + 1]
  end
end
