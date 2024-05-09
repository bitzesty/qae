# We are using Pusher with Poxa server
# for collaborators application edit stuff
#

Pusher.host = ENV["PUSHER_SOCKET_HOST"]
Pusher.port = ENV["PUSHER_WS_PORT"].to_i
Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key = ENV["PUSHER_APP_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]

if Rails.env.production? || Rails.env.staging?
  # Set encrypted on staging and live as they are using HTTPS

  Pusher.encrypted = true
end
