class UserPolicy < ApplicationPolicy
  %w[index? update? create? show? new?].each do |method|
    define_method method do
      admin?
    end
  end
end
