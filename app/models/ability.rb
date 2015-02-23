class Ability
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def can?(action, resource)
    actions = public_send("#{user.role}_actions")[resource]

    if actions.is_a?(Array)
      actions.include?(:manage) || actions.include?(action)
    else
      actions == :manage || actions == action
    end
  end

  def admin_actions
    {
      dashboard: :read,
      users: :manage,
      assessors: :manage,
      admins: :manage,
      comments: :manage,
      form_answers: :manage,
      form_answer_attachments: :manage,
      notifications: :manage,
      flags: :toggle
    }
  end

  def lead_assessor_actions
    {
      dashboard: :read,
      form_answers: :read,
      form_answer_attachments: :manage,
      comments: [:read, :create],
      flags: :toggle
    }
  end

  def assessor_actions
    {
      dashboard: :read,
      form_answers: :read,
      form_answer_attachments: :manage,
      comments: [:read, :create],
      flags: :toggle
    }
  end
end
