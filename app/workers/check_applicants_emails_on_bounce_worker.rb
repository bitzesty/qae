class CheckApplicantsEmailsOnBounceWorker
  include Sidekiq::Worker

  def perform
    User.order(id: :asc).where(debounce_api_response_code: "7").find_each.map do |user|
      CheckAccountOnBouncesEmail.new(
        user
      ).run!

      sleep 0.5
    end
  end
end
