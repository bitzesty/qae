class UserPolicy < ApplicationPolicy
  %w[index? update? create? show? new? can_add_collaborators_to_account?].each do |method|
    define_method method do
      admin?
    end
  end
end
