module FullNameDecorator
  def full_name
    if object.first_name.present?
      "#{object.first_name} #{object.last_name}"
    else
      "Anonymous"
    end
  end
end
