class CollaboratorsChannel < ApplicationCable::Channel
  def subscribed
    stream_from params["channel_name"]
    collaborators = Rails.cache.read(params["channel_name"])
    user = User.find(params["user_id"])

    if collaborators.blank?
      collaborators = ["#{user.id}:#{params["current_tab"]}:#{user.email}:#{user.full_name}:EDITOR"]
    else
      collaborators << "#{user.id}:#{params["current_tab"]}:#{user.email}:#{user.full_name}"
    end

    Rails.cache.write(params["channel_name"], collaborators, expires_in: 60.minutes)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], collaborators)
  end

  def unsubscribed
    user_id = params["user_id"]
    new_collaborators = []
    collaborators = Rails.cache.read(params["channel_name"])

    collaborators.each do |collaborator|
      # remove the unsubscribing user
      new_collaborators << collaborator unless collaborator.split(":")[0] == user_id && collaborator.split(":")[1] == params["current_tab"]
    end

    if new_collaborators.any? && new_collaborators.join.exclude?("EDITOR")
      # editor has left the channel, so we update the next in line to be editor
      temp_collabs = new_collaborators
      temp_collabs[0] += ":EDITOR"
      new_collaborators = temp_collabs
    end

    Rails.cache.write(params["channel_name"], new_collaborators, expires_in: 60.minutes)

    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], new_collaborators)
  end
end
