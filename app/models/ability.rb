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
      users: :manage,
      assessors: :manage,
      admins: :manage,
      form_answers: :manage
    }
  end

  def lead_assessor_actions
    {
      form_answers: [:read, :comment]
    }
  end

  def assessor_actions
    {
      form_answers: [:read, :comment]
    }
  end
end
