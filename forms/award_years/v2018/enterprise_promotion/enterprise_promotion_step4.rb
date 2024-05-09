# -*- coding: utf-8 -*-

class AwardYears::V2018::QaeForms
  class << self
    def promotion_step4
      @promotion_step4 ||= proc do
        header :support_letters_intro, "" do
          context %(
            <p>
              As nominator you have sole responsibility for sourcing at least 2 letters of support. Nominations with less than 2 letters will not be accepted. We recommend asking 3-5 supporters to ensure you meet the minimum requirements, as some people might not reply.
            </p>

          )

          hint "Who should I choose to write letters of support?", %(
            <p>
              Letters of support should be from those with first-hand knowledge of the nominee's contribution to enterprise promotion and the impact their work has had on others. This could be colleagues, collaborators, or those who have benefitted from their work. You, the nominator, may not write a letter of support.
            </p>
            <p>
              At least one letter should be from a large organisation (eg. employer, nonprofit, college, local authority) able to provide an assessment of the extent to which the nominee's contribution sets them aside from their peers.
            </p>
            <p>
              When selecting supporters, you should cover a variety of the nominee's activities, and a variety of perspectives on those activities, where possible.
            </p>
          )

          hint "How does the letters of support system work?", %(
            <p>
              First, you should enter details of your chosen supporters below and click on the 'Send support request' button. We will then email them a link to a web form, where they can enter their letter of support.
            </p>
            <p>
              They will be given instructions as to what to include in their letter.
            </p>
            <p>
              We will also send them your email address so they can notify you if they will not be submitting a letter of support, or contact you with any questions.
            </p>
            <p>
              Supporters are much more likely to submit letters promptly if you follow up our initial email by phoning them yourself.
            </p>
            <p>
              <strong>
                If you have supporters who would rather write a hard copy letter, please see question D2.
              </strong>
            </p>

            <br>
          )

          hint "See the guidance we will provide to your chosen supporters.", %(
            <p>
              <strong>
                What should be included in a letter of support?
              </strong>
            </p>
            <p>
              Letters of support should be about 500 words in length, making it clear why a nomination is being supported and NOT simply saying “I wish to support the nomination of …”.
            </p>
            <p>
              The Queen's Award for Enterprise Promotion recognises individuals who go beyond the limits of their day-to-day role to foster an entrepreneurial spirit and promote enterprise within others, so your letter should focus mainly on the nominee's achievements outside of the requirements of their paid job, using your first hand knowledge of these where possible.
            </p>
            <p>
              Ideally, we are looking for evidence that demonstrates the clear impact of the nominee's activities in enterprise promotion:
            </p>
            <ul>
              <li>
                <p>
                  Qualitative and quantitative evidence of the impact resulting from the nominee's services to a particular field, area, group, community, location or society as a whole. Financials are not expected, but some quantifiable data is e.g. a number of schools visited, length of time involved or number of enterprises helped to set up and percentage of those still trading.
                </p>
              </li>
              <li>
                <p>
                  A personal perspective from those who have benefited from, or had direct experience of, the success of the nominee's work, including the impact it has had on them or their business.
                </p>
              </li>
            </ul>
            <p>
              If you are writing on behalf of an organisation, you should be able to provide an assessment of the extent to which the nominee's activities set them apart from their peers."
            </p>
          )
        end

        supporters :supporters, "Support Requests" do
          classes "question-support-requests"
          ref "D 1"
          limit 10
          default 1
        end

        options :manually_upload, "Would you like to manually upload any of your letters of support?" do
          ref "D 2"
          required
          yes_no
          context %(
            <p>
              This is for any of your supporters who would rather write a hard copy letter and send it to you directly.
            </p>
          )
        end

        supporters :supporter_letters_list, "Manual upload" do
          context %(
            <p>
              Here you can manually upload letters of support each up to 5mb in size. This is for any of your supporters who would rather write a hard copy letter and send it to you directly.
            </p>
          )

          hint "I want to manually upload my letters of support.", %(
            <p>
              You should first confirm that your chosen supporter(s) are willing and able to write a letter of support for your nominee, then <strong>send them the letter of support guidelines below</strong>.
            </p>
            <p>
              Make sure they submit the letter to you well before the nomination deadline.
            </p>
            <p>
              You can then upload the letter(s) of support here.
            </p>
            <p>
              If you haven't already, please see the guidance at the top of this page for information on choosing supporters.
            </p>
          )

          hint "Letters of support guidelines.", %(
            <p>
              Letters of support should be around 500 words, making it clear why a nomination is being supported and NOT simply saying “I wish to support the nomination of ….”.
            </p>
            <p>
              The Queen's Award for Enterprise Promotion recognises individuals who go beyond the limits of their day-to-day role to foster an entrepreneurial spirit and promote enterprise within others, so your letter should focus mainly on the nominee's achievements outside of the requirements of their paid job, using your first hand knowledge of these where possible.
            </p>
            <p>
              Ideally, we are looking for evidence that demonstrates the clear impact of the nominee's activities in enterprise promotion:
            </p>
            <ul>
              <li>
                Qualitative and quantitative evidence of the impact resulting from the nominee's services to a particular field, area, group, community, location or society as a whole. Financials are not expected, but some quantifiable data is e.g. a number of schools visited, length of time involved or number of enterprises helped to set up and percentage of those that are still trading.
              </li>
              <li>
                A personal perspective from those who have benefited from, or had direct experience of, the success of the nominee's work, including the impact it has had on them or their business.
              </li>
            </ul>
            <p>
              If you are writing on behalf of an organisation, you should be able to provide an assessment of the extent to which the nominee's activities set them apart from their peers.
            </p>
            <p>
              All letters of support should include the contact details of the writer, and their relationship to the nominee.
            </p>
          )

          hint "What are the allowed file formats?", %(
            <p>
              You can upload any of the following file formats:
            </p>
            <p>
              chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip
            </p>
          )

          classes "question-support-uploads"
          limit 4
          default 1
          list_type :manuall_upload
          conditional :manually_upload, :yes
        end
      end
    end
  end
end
