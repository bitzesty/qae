class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_#{params[:room]}"
    current_user.appear(params[:room])
  end

  def unsubscribed
    current_user.disappear(params[:room])
  end

  def appear(data)
    current_user.appear(data['appearing_on'])
  end

  def away
    current_user.away
  end
end
