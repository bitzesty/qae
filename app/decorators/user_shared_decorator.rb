module UserSharedDecorator
  def full_name
    if object.first_name.present?
      "#{object.first_name} #{object.last_name}"
    else
      "Anonymous"
    end
  end

  def formatted_last_sign_in_at
    object.last_sign_in_at && object.last_sign_in_at.strftime("%e %B %Y at %H:%M")
  end
end
