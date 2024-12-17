class GeneralRoomChannel < ApplicationCable::Channel
  def subscribed
    room_members = Rails.cache.read(params["channel_name"]) || []
    room_members << user_identifier if room_members.exclude?(user_identifier)
    stream_from params["channel_name"]
    Rails.cache.write(params["channel_name"], room_members, expires_in: 60.minutes)
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end

  def unsubscribed
    room_members = Rails.cache.read(params["channel_name"]) || []
    room_members.delete(user_identifier)
    Rails.cache.write(params["channel_name"], room_members, expires_in: 60.minutes)
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end

  private

  def user_identifier
    "#{params["user_id"]}-#{params["current_tab"]}"
  end
end
