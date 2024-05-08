class Users::CollaboratorAccessController < Users::BaseController

  # stop rails CSRF protection for pusher authentication
  protect_from_forgery except: :auth

  expose(:user_id) do
    "#{current_user.id}-time-#{params[:timestamp]}"
  end

  expose(:pusher_callback) do
    params[:callback]
  end

  def auth
    response = Pusher[params[:channel_name]].authenticate(
      params[:socket_id], {
        user_id: user_id,
        user_info: {
          name: current_user.full_name,
          email: current_user.email,
          section: params[:section],
          joined_at: params[:timestamp]
        }
      }
    )

    render(
      plain: "#{pusher_callback}(#{response.to_json})",
      content_type: "application/javascript"
    )
  end
end
