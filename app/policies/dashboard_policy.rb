class DashboardPolicy < Struct.new(:user, :dashboard)
  def index?
    true
  end
end
