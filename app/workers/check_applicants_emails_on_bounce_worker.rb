class CheckApplicantsEmailsOnBounceWorker
  include Sidekiq::Worker

  def perform
    User.not_checked_on_bounced_emails.find_each(limit: 100).map do |user|
      CheckAccountOnBouncesEmail.new(
        user
      ).run!

      sleep 0.5
    end
  end
end
