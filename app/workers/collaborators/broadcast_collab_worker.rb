class Collaborators::BroadcastCollabWorker
  include Sidekiq::Worker

  def perform(channel_name, collaborators)
    ActionCable.server.broadcast(channel_name, { collaborators: collaborators }) unless collaborators.nil?
  end
end
