#
# Manual Submission of FormAnswer
#
# Use:
#
# ::ManualUpdaters::SubmitApplication.new(form_answer).run!
#

module ManualUpdaters
  class SubmitApplication
    attr_accessor :form_answer

    def initialize(form_answer)
      @form_answer = form_answer
    end

    def run!
      # STEP 1: Set submitted fields
      #
      form_answer.update_column(:submitted, true)
      form_answer.update_column(:submitted_at, Time.current)

      # STEP 2: Assign URN
      #
      generated_urn = UrnBuilder.new(form_answer).generate_urn

      if generated_urn.present?
        # STEP 3: If URN generate successfuly, THEN:

        # save URN
        #
        form_answer.update_column(:urn, generated_urn)

        # trigger state
        #
        form_answer.state_machine.submit(form_answer.user)

        # notify user about successful submission
        #
        FormAnswerUserSubmissionService.new(form_answer).perform

        # generate hard copy PDF file
        #
        puts "****************************************************************************************"
        puts "generate hard copy PDF file"
        HardCopyPdfGenerators::FormDataWorker.perform_async(form_answer.id, true)

        Rails.logger.debug ""
        Rails.logger.debug "[MANUAL SUBMISSION | SUCCESS] DONE! Check it at https://www.kings-awards-enterprise.service.gov.uk/admin/form_answers/#{form_answer.id}"
      else
        Rails.logger.debug ""
        Rails.logger.debug "[MANUAL SUBMISSION | ERROR] seems URN is not generated! Please, check why!"
      end
      Rails.logger.debug ""
    end
  end
end
