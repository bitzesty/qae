class CustomEmailWorker
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg, request)
    puts "processing email #{request}"
    CustomEmailForm.new(JSON.parse(request).with_indifferent_access).send!
  end
end
