class GeneralRoomChannel < ApplicationCable::Channel
  def subscribed
    room_members = Rails.cache.read(params["channel_name"])

    if room_members.blank?
      room_members = [params["user_id"]]
    elsif room_members.exclude?(params["user_id"])
      room_members << params["user_id"]
    end

    stream_from params["channel_name"]

    Rails.cache.write(params["channel_name"], room_members, expires_in: 60.minutes)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end

  def unsubscribed
    room_members = Rails.cache.read(params["channel_name"])

    room_members.delete(params["user_id"])

    Rails.cache.write(params["channel_name"], room_members, expires_in: 60.minutes)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end
end
