class QAE2014Forms
  class << self
    def innovation_step5
      @innovation_step5 ||= Proc.new {
        # TODO Pull in info for A13
        confirm :confirmation_of_consent, 'Confirmation of consent' do
          ref 'E 1'
          required
          text 'I confirm that I have the consent of the head of my organisation (as in A13) to submit this entry form.'
        end

        confirm :agree_to_be_contacted_by_qae, "Contact from Queen's Award for Enterprise" do
          ref 'E 2'
          text "I am happy to be contacted about Queen's Award for Enterprise issues not related to my application (e.g. acting as a case study, newsletters, other info)."
        end

        confirm :agree_to_be_contacted_by_dept, "Contact from Department of Business, Innovation and Skills." do
          ref 'E 3'
          text "I am happy to be contacted by the Department of Business, Innovation and Skills."
        end

        confirm :entry_confirmation, 'Confirmation of entry' do
          ref 'E 4'
          required
          text %Q{
            By ticking this box, I certify that all the particulars given and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen’s Awards Office of any changes to the information I have provided in this entry form.
            <br>
            <br>
            I am not aware of any matter which might cast doubt upon the worthiness of this business unit to receive a Queen’s Award. I consent to all necessary enquiries being made by The Queen’s Awards Office in relation to this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen’s Award to ensure the highest standards of propriety. 
          }
        end


        submit "Submit application" do
          notice %Q{
            <p>If you have answered all the questions, you can submit your application now. You will be able to edit it any time before 23:59 on the last working day of September.</p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
          }
          style "large"
        end
      }
    end
  end
end
