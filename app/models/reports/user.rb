class Reports::User

  def initialize(user)
    @user = user
  end

  def call_method(methodname)
    return "not implemented" if methodname.blank?

    if respond_to?(methodname, true)
      send(methodname)
    elsif @user.respond_to?(methodname)
      @user.send(methodname)
    else
      "N/A"
    end
  end

  private

  def user_type
    @user.class.name
  end

  def awards_assigned
    if @user.is_a?(Assessor) || @user.is_a?(Judge)
      @user.roles
        .reject{ |role| role =~ /promotion/ }
        .map{ |role| FormAnswer::AWARD_TYPE_FULL_NAMES[role] }
        .join(", ")
    else
      "N/A"
    end
  end
end
