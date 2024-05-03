# We are using Pusher with Poxa server
# for collaborators application edit stuff
#

Pusher.host = ENV.fetch("PUSHER_SOCKET_HOST", nil)
Pusher.port = ENV["PUSHER_WS_PORT"].to_i
Pusher.app_id = ENV.fetch("PUSHER_APP_ID", nil)
Pusher.key = ENV.fetch("PUSHER_APP_KEY", nil)
Pusher.secret = ENV.fetch("PUSHER_SECRET", nil)

if Rails.env.production? || Rails.env.staging?
  # Set encrypted on staging and live as they are using HTTPS

  Pusher.encrypted = true
end
