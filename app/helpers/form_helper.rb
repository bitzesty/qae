module FormHelper
  def possible_read_only_ops(submission=nil)
    ops = {}

    if admin_in_read_only_mode? || (submission && !current_user.account_admin?)
      ops[:disabled] = 'disabled'  
      ops[:class] = 'read_only'
    end

    ops
  end
end