class QAE2014Forms
  class << self
    def promotion_step5
      @promotion_step5 ||= proc do
        upload :innovation_materials, "If there is additional material you feel would help us to assess your nomination then you can add up to 4 files or website addresses here." do
          ref "E 1"
          context %(
            <p>
              We can't guarantee these will be reviewed, so include any vital information within the form.
            </p>
            <p>
              You can upload files in all common formats, as long as they're less than 5mb each.
            </p>
            <p>
              You may link to videos, websites or other media you feel relevant.
            </p>
            <p>
              We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.
            </p>
          ) # TODO!
          max_attachments 4
          links
          description
        end
      end
    end
  end
end
