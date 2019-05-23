class ApplicantEmailDebounceApiCheckWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.check_email_on_bounces!
  end
end
