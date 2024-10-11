class GeneralRoomChannel < ApplicationCable::Channel
  def subscribed
    room_members = Rails.cache.read(params["channel_name"])

    if room_members.blank?
      room_members = params["user_id"]
    elsif room_members.split("/").exclude?(params["user_id"])
      room_members += "/#{params["user_id"]}"
    end

    stream_from params["channel_name"]

    Rails.cache.write(params["channel_name"], room_members)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end

  def unsubscribed
    room_members = Rails.cache.read(params["channel_name"])

    tmp_room_members = room_members.split("/")
    tmp_room_members.delete(params["user_id"])
    room_members = tmp_room_members.join("/")

    Rails.cache.write(params["channel_name"], room_members)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], room_members)
  end
end
