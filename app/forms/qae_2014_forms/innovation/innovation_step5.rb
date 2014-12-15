class QAE2014Forms
  class << self
    def innovation_step5
      @innovation_step5 ||= Proc.new {
        options :agree_to_be_contacted, %Q{We will contact you regarding your entry. We may also wish to contact you about other issues relating to The Queen's Awards for Enterprise (eg. acting as a case study). Are you happy for us to do this?} do
          ref 'E 1'
          yes_no
        end

        # This section will be pre-filled with the account details provided during registration
        contact :contact, 'Details of a contact within your business for application-related enquiries' do
          ref 'E 2'
          required
        end

        text :contact_position, 'Position' do
          classes "sub-question"
          required
        end

        contact_email :contact_email, 'Email address' do
          classes "sub-question"
          required
        end

        text :contact_phone, 'Telephone number' do
          classes "sub-question"
          required
          style "small"
        end

        confirm :confirmation_of_consent, 'Confirmation of consent' do
          ref 'E 3'
          required
          text 'I confirm that I have the consent of the Head of the applicant business (as identified in A11) to submit this entry form.'
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
            <p>You can still edit your submitted application at any time before 23:59 on the last working day of September.</p>
          }
          style "large"
        end
      }
    end
  end
end
