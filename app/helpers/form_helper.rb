module FormHelper
  def possible_read_only_ops
    ops = {}

    if admin_in_read_only_mode?
      ops[:disabled] = 'disabled'  
      ops[:class] = 'read_only'
    end

    ops
  end
end