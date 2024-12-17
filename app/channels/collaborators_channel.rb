class CollaboratorsChannel < ApplicationCable::Channel
  def subscribed
    stream_from params["channel_name"]
    collaborators = Rails.cache.read(params["channel_name"]) || []
    collaborators << user_hash(params["user_id"])
    Rails.cache.write(params["channel_name"], collaborators, expires_in: 60.minutes)
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], collaborators)
  end

  def unsubscribed
    collaborators = Rails.cache.read(params["channel_name"]) || []
    collaborators.reject! { |c| c["id"] == params["user_id"] && c["tab_ident"] == params["current_tab"] }
    Rails.cache.write(params["channel_name"], collaborators, expires_in: 60.minutes)
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], collaborators)
  end

  private

  def user_hash(user_id)
    user = User.find(params["user_id"])

    {
      "id" => user.id.to_s,
      "email" => user.email,
      "name" => user.full_name,
      "tab_ident" => params["current_tab"],
    }
  end
end
