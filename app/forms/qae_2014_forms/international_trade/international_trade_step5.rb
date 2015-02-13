class QAE2014Forms
  class << self
    def trade_step5
      @trade_step5 ||= Proc.new {
        upload :innovation_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'E 1'
          context %Q{
            <p>We can't guarantee these will be reviewed, so include any vital information within the form.</p>
            <p>You can upload files in all common formats, as long as they're less than 5mb.</p>
            <p>You may link to videos, websites or other media you feel relevant.</p>
            <p>We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.</p>
          } # TODO!
          max_attachments 4
          links
          description
        end
      }
    end
  end
end
