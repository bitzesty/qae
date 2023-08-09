# -*- coding: utf-8 -*-
class AwardYears::V2018::QaeForms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :mobility_b_section_header, "" do
          context %(
            <p>
              This section gives you the opportunity to present details of your social mobility programme and gives evidence on how your programme benefits your staff and your organisation, to enable us to assess your application.
            </p>
            <p>
              If you have more than one social mobility programme, provide details.
            </p>
            <p>
              Please note, a programme could be an initiative, activity, course, system, business model approach or strategy, service or application, practice, policy or product.
            </p>
            <p>
              Please try to avoid using technical jargon in this section.
            </p>
          )
        end

        checkbox_seria :application_relate_to, "This entry relates to:" do
          ref "B 1"
          required
          context %(
            <p>Select all that apply</p>
          )
          check_options [
            ["mentoring", "A programme which provides careers advice, skills development or mentoring that prepare young people for the world of work and/or accessible structured work experience."],
            ["career_opportunities_accessibility", "A programme which makes career opportunities more accessible by offering non-graduate routes such as traineeships, apprenticeships or internships, or by reforming recruitment practices."],
            ["workplace_fostering", "A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers."]
          ]
          application_type_question true
        end

        regions :programme_regions, "In which region(s) does your programme have an impact?" do
          classes "sub-question"
          sub_ref "B 1.1"
          required
          context %(
            <p>Select all that apply</p>
          )
        end

        textarea :mobility_desc_long, "Summarise your social mobility programme" do
          classes "sub-question"
          sub_ref "B 1.2"
          required
          context %(
            <p>
              This is to help us understand the essence of your programme. The summary might be used in publicity material if your application is successful.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :mobility_desc_short, "Provide a one line description of your social mobility programme" do
          classes "sub-question"
          sub_ref "B 1.3"
          required
          context %(
            <p>
              This description will be used in publicity material if your application is successful.
            </p>
          )
          words_max 15
        end

        textarea :provide_ceo_quote, "Provide a quote from the CEO that demonstrates support for the social mobility programme" do
          classes "sub-question"
          sub_ref "B 1.4"
          required
          classes "word-max-strict"
          context %(
            <p>
              This quote might be used in publicity material if your application is successful.
            </p>
          )
          rows 5
          words_max 100
        end

        textarea :business_cause, "What was the business case that motivated your organisation to introduce/ provide the programme? What was the situation before the inception of this programme?" do
          required
          ref "B 2"
          rows 5
          words_max 400
        end

        textarea :programme_cause, "Why did you choose this particular programme and how does it align with the core aims and values of your organisation?" do
          classes "sub-question"
          required
          ref "B 2.1"
          rows 5
          words_max 250
        end

        textarea :investments_return_prediction, "How do you ensure that the programme provides a good return on investment for your organisation, financially or otherwise?" do
          ref "B 3"
          required
          context %(
            <p>How much is invested in the programme - consider financial, human resource or in-kind investment. How does the scale of this investment compare with wider talent management activities?</p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_return_responsibility, "Who is ultimately responsible for the success of the programme? What is the management structure to ensure the day-to-day management of the programme from board level down?" do
          classes "sub-question"
          sub_ref "B 3.1"
          required
          context %(
            <p>
              You may include chart(s) to make it easier for assessors to understand how your programme is managed in section E.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :programme_kpis, "What are the KPIs related to the programme? How are they set and monitored? Are the KPIs being met and what happens if they are not met?" do
          classes "sub-question"
          sub_ref "B 3.2"
          context %(
            <p>What impact did you set out to achieve with the programme in terms of your objectives and KPIs.</p>

            <p>State what quantifiable measures were used to evaluate the success of the programme.</p>
          )
          required
          rows 5
          words_max 400
        end

        textarea :programme_integration, "Describe how the programme is integrated into the overall business strategy, and what the board/ senior management level commitment to the future growth of the programme is" do
          ref "B 4"
          required
          context %(
            <p>Provide a vision of what your organisation wants to do in terms of the programme, as well as evidence of how you have gone about integrating the programme to date.</p>
          )
          rows 5
          words_max 250
        end

        textarea :benefits_communication, "What mechanisms are in place to communicate the benefits of the programme to employees, key internal and external stakeholders?" do
          classes "sub-question"
          sub_ref "B 4.1"
          required
          context %(
            <p>
              You can include in your answer below or attach in section E: newsletters, quotes or similar material to bring to life exactly how you communicate the value of your programme.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :organisation_culture_fosters, "Describe how your organisation’s culture fosters and supports the social mobility programme" do
          classes "sub-question"
          sub_ref "B 4.2"
          required
          rows 5
          words_max 250
        end

        textarea :programme_benefit_evidence, "Provide evidence on how the programme benefits the people it is aimed at" do
          ref "B 5"
          required
          context %(
            <p>
             You should demonstrate positive impacts in at least two of the following areas:
            </p>
            <ul>
              <li>
                Careers advice - helping people to make more informed choices by providing careers advice or information;
              </li>
              <li>
                Work placements - preparing people for the world of work through inspiring work experiences and internships;
              <li>
                Fairer recruitment - making your recruitment process fairer and more focused on attitude and aptitude;
              </li>
              <li>
                Accessible routes - broadening access to your job opportunities by creating accessible routes to employment - e.g. providing careers advice and jobs for people leaving school, college or university; quality traineeships, internships or apprenticeships and graduate schemes;
              </li>
              <li>
                Early careers -  fostering a ‘youth-friendly’ culture in your workplace where young employees are invested in and developed to progress in their careers;
              </li>
              <li>
                Advancement - developing career paths to senior positions that are open to all;
              </li>
              <li>
                Visible leadership and accountability - do you have leaders within the business championing social mobility and being role models? Are your managers accountable in that social mobility is part of their objectives?
              </li>
            </ul>
            <p>
              Wherever possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence to support your application.
            </p>
            <p>
              Focus on what impact your activities have achieved to date, but include the longer term outcomes as well.
            </p>
            <p>
              Also consider the potential impact on those people benefiting from your social mobility programme if it had never been introduced.
            </p>
          )

          pdf_context %(
            <p>
             You should demonstrate positive impacts in at least two of the following areas:
            </p>
            <p>
              \u2022 Careers advice - helping people to make more informed choices by providing careers advice or information;

              \u2022 Work placements - preparing people for the world of work through inspiring work experiences and internships;

              \u2022 Fairer recruitment - making your recruitment process fairer and more focused on attitude and aptitude;

              \u2022 Accessible routes - broadening access to your job opportunities by creating accessible routes to employment - e.g. providing careers advice and jobs for people leaving school, college or university; quality traineeships, internships or apprenticeships and graduate schemes;

              \u2022 Early careers -  fostering a ‘youth-friendly’ culture in your workplace where young employees are invested in and developed to progress in their careers;

              \u2022 Advancement - developing career paths to senior positions that are open to all;

              \u2022 Visible leadership and accountability - do you have leaders within the business championing social mobility and being role models? Are your managers accountable in that social mobility is part of their objectives?
            </p>
            <p>
              Wherever possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence to support your application.
            </p>
            <p>
              Focus on what impact your activities have achieved to date, but include the longer term outcomes as well.
            </p>
            <p>
              Also consider the potential impact on those people benefiting from your social mobility programme if it had never been introduced.
            </p>
          )
          rows 8
          words_max 700
        end

        textarea :employability_improvement_evidence, "Provide evidence on how your organisation improved the employability of your people and how it has raised their career aspirations and confidence" do
          classes "sub-question"
          sub_ref "B 5.1"
          required
          context %(
            <p>
              Improvements in employability could be as a result of teaching skills such as leadership, communications, team-work, resilience, etc.
            </p>
            <p>
              If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.
            </p>
            <p>
              Focus on what impact your activities have achieved to date, but include the longer term outcomes as well.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :financial_benefits_evidence, "Provide evidence on how the programme benefits your organisation" do
          ref "B 6"
          required
          context %(
            <p>Benefits can be demonstrated in many areas, below are some examples:</p>
            <ul>
              <li>Employee relations - improvements in employee motivation, well-being or satisfaction;</li>
              <li>Diversity - increased ability to access and attract a wider talent pool;</li>
              <li>Reputation - increased positive perceptions of the organisation among key stakeholders - e.g. customers and the media;</li>
              <li>Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration;</li>
              <li>Savings - reduced recruitment costs, increases in retention;</li>
              <li>Growth - increased sales, access to new clients or markets or the development of new products.</li>
            </ul>
            <p>If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.</p>
            <p>You may find it helpful to articulate these benefits in terms of ‘before and after’.</p>
            <p>Describe how would your business be affected if this social mobility programme had never been introduced.</p>
          )
          pdf_context %(
            <p>Benefits can be demonstrated in many areas, below are some examples:</p>
            <p>
              \u2022 Employee relations - improvements in employee motivation, well-being or satisfaction;

              \u2022 Diversity - increased ability to access and attract a wider talent pool;

              \u2022 Reputation - increased positive perceptions of the organisation among key stakeholders - e.g. customers and the media;

              \u2022 Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration;

              \u2022 Savings - reduced recruitment costs, increases in retention;

              \u2022 Growth - increased sales, access to new clients or markets or the development of new products.
            </p>
            <p>If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.</p>

            <p>You may find it helpful to articulate these benefits in terms of ‘before and after’.</p>

            <p>Describe how would your business be affected if this social mobility programme had never been introduced.</p>
          )
          rows 5
          words_max 750
        end

        textarea :exemplary_evidence, "Provide evidence on what makes your social mobility programme exemplary?" do
          ref "B 7"
          required
          context %(
            <p>
              For example, the programme may be exemplary as a result of:
            </p>
            <ul>
              <li>An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;</li>
              <li>Developing a unique or innovative social mobility programme;</li>
              <li>Forming effective partnerships with charities, schools or job centres;</li>
              <li>Leading the way in your company by doing something that has never been done before.</li>
            </ul>
            <p>
              The above are just examples - you can describe other reasons if more suitable.
            </p>
            <p>
              If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.
            </p>
          )
          pdf_context %(
            <p>
              For example, the programme may be exemplary as a result of:
            </p>
            <p>
              \u2022 An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;

              \u2022 Developing a unique or innovative social mobility programme;

              \u2022 Forming effective partnerships with charities, schools or job centres;

              \u2022 Leading the way in your company by doing something that has never been done before.
            </p>
            <p>
              The above are just examples - you can describe other reasons if more suitable.
            </p>
            <p>
              If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.
            </p>
          )
          rows 8
          words_max 800
        end
      end
    end
  end
end
