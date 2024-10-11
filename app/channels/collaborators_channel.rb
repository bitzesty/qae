class CollaboratorsChannel < ApplicationCable::Channel
  def subscribed
    puts "subscribing user id #{params["user_id"]} to #{params["channel_name"]}"
    puts params
    stream_from params["channel_name"]
    collaborators = Rails.cache.read(params["channel_name"])
    user = User.find(params["user_id"])

    if collaborators.nil? || collaborators.empty?
      string = "#{user.id}:#{user.email}:#{user.full_name}:EDITOR"
      Rails.cache.write(params["channel_name"], string)
      collaborators = string
    elsif collaborators.is_a?(String) && !collaborators.include?(params["user_id"]) # will not work with just a user id
      string = collaborators += "/#{user.id}:#{user.email}:#{user.full_name}"
      Rails.cache.write(params["channel_name"], string)
      collaborators = string
    end

    puts "subscribed - collaborator list: #{collaborators}"
      
    # ActionCable.server.broadcast(params["channel_name"], { collaborators: collaborators }) unless collaborators.nil?
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], collaborators)
  end

  def unsubscribed
    puts "unsubscribing user_id #{params["user_id"]} from channel: #{params["channel_name"]}"

    user_id = params["user_id"]
    collaborators = Rails.cache.read(params["channel_name"])
    new_collaborators = ""
    collaborators.split("/").each do |collaborator|
      new_collaborators += collaborator unless collaborator.split(":")[0] == user_id
    end

    if !new_collaborators.empty? && !new_collaborators.include?("EDITOR")
      # editor has left the channel, so we update the next in line to be editor
      temp_collabs = new_collaborators.split("/")
      temp_collabs[0] += ":EDITOR"
      new_collaborators = temp_collabs.join("/")
    end

    if new_collaborators.empty?
      puts "new collabs will be empty"
    else
      puts "new collabs will be: #{new_collaborators}"
    end
    
    Rails.cache.write(params["channel_name"], new_collaborators)

    # ActionCable.server.broadcast(params["channel_name"], { collaborators: new_collaborators })
    Collaborators::BroadcastCollabWorker.perform_async(params["channel_name"], new_collaborators)

  end
end
