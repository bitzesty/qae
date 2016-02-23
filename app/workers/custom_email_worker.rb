class CustomEmailWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(sqs_msg, request)
    puts "processing email #{request}"
    CustomEmailForm.new(JSON.parse(request).with_indifferent_access).send!
  end
end
