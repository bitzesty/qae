ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
  duration = (finish - start) * 1000
  Thread.current[:response_time] = duration.round(3)
end
