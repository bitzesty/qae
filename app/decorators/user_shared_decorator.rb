module UserSharedDecorator
  def full_name
    if object.first_name.present?
      "#{object.first_name} #{object.last_name}"
    else
      "Anonymous"
    end
  end

  def formatted_last_sign_in_at_long
    object.last_sign_in_at && object.last_sign_in_at.strftime("%e %b %Y at %-l:%M%P")
  end

  def formatted_last_sign_in_at_short
    object.last_sign_in_at && object.last_sign_in_at.strftime("%d/%m/%Y %-l:%M%P")
  end
end
