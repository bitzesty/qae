class AwardYears::V2019::QaeForms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :mobility_b_section_header, "" do
          context %(
            <p>
              This section enables you to present the details of your social mobility programme and to give us the evidence on how your programme benefits your staff and your organisation, allowing us to assess your application.
            </p>
            <p>
              If you have more than one social mobility programme, provide details.
            </p>
            <p>
              Please note, a programme could be an initiative, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach programmes.
            </p>
            <details>
              <summary><span class="summary">Please read more about social mobility programmes that are eligible for The Queen's Awards for Enterprise.</span></summary>

              <div class="panel panel-border-narrow">

                <p>
                  Socio-economic background is a set of social and economic circumstances from which a person has come.
                </p>

                <p>
                  Socio-economic status is a person's current social and economic circumstances.
                </p>

                <p>
                  Social mobility is a measure of the ability to move from lower socio-economic background to higher socio-economic status.
                </p>

                <p>
                  We classify people as being from a lower or higher socio-economic background based on these variables:
                </p>

                <ol>
                  <li>
                    The National Statistics Socio-economic classification (NS-SEC) of parent's occupation. This is based on the type of job the main or highest income earner in the household had as their main job when the person was 14.
                  </li>
                  <li>
                    Whether they were receiving free school meals.
                  </li>
                  <li>
                    The highest level of qualifications achieved by either parent(s) or guardian(s) by the time the person was 18.
                  </li>
                  <li>
                    The type of school the person attended.
                  </li>
                </ol>
                <p>
                  We are looking to recognise those who are going above and beyond their core day-to-day business, acting to improve social mobility within their company locally or nationally, accessing and retaining talent regardless of socio-economic background.
                </p>

                <p>
                  Please note, an award is unlikely to be granted to a social enterprise, learning provider or charity whose main purpose is to deliver social mobility programmes either for itself or on behalf of other organisations. This is because we are seeking to reward and encourage companies to address social mobility challenges within their organisations, despite this not being their sole objective.
                </p>

                <p>
                  Applicants must be able to demonstrate at least two of the following:
                </p>

                <p>
                  Accessible routes - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.
                </p>

                <p>
                  Careers advice – provide careers advice or information to help people make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.
                </p>

                <p>
                  Work placements - preparing people for the world of work through inspiring work experiences and internships;
                </p>

                <p>
                  Fairer recruitment - widening your recruitment pool and making your recruitment       process fairer by assessing potential skills rather than background - social-economic    or academic. For example, by removing applicant's name or school names from CVs, providing unconscious bias training for recruitment assessors.
                </p>

                <p>
                  Early careers - fostering a 'youth-friendly' culture in your workplace where young employees from disadvantaged backgrounds are invested in and developed to progress in their careers;
                </p>

                <p>
                  Advancement - developing career paths to senior positions that are open to all and track the progress of employees from non-graduate routes.
                </p>

                <p>
                  Advocacy and leadership - demonstrate strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.
                </p>

                <p>
                  You must provide evidence of how your programme has increased social mobility and real evidence of what the outcomes are for the participants.
                </p>

                <p>
                  For example, if you have a programme for prisoners or ex-offenders, include details on what proportion of those on the programme come from disadvantaged backgrounds.  If you are offering work placements or work experience, include statistics on what percentage of those people then go on into full-time employment, either within your company or the sector.
                </p>
              </div>

            </details>
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
            ["mentoring",
             "A programme which provides careers advice, skills development or mentoring that prepare young people from disadvantaged or lower socio-economic backgrounds for the world of work or accessible, structured work experience."],
            ["career_opportunities_accessibility",
             "A programme which makes career opportunities more accessible by offering non-graduate routes such as well-structured traineeships, apprenticeships or internships, or by reforming recruitment practices and offering clear paths for progression."],
            ["workplace_fostering",
             "A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers and champions a culture of inclusiveness at every level."],
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

        textarea :mobility_desc_long, "Summarise your social mobility programme." do
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

        textarea :mobility_desc_short, "Provide a one-line description of your social mobility programme." do
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

        textarea :provide_ceo_quote, "Provide a quote from the CEO that demonstrates support for the social mobility programme." do
          classes "sub-question word-max-strict"
          sub_ref "B 1.4"
          required
          context %(
            <p>
              This quote might be used in publicity material if your application is successful.
            </p>
          )
          rows 5
          words_max 100
        end

        textarea :business_cause,
                 "What factors or issues motivated your organisation to provide the programme? What was the situation before the inception of this programme?" do
          required
          ref "B 2"
          rows 5
          words_max 400
        end

        textarea :programme_cause,
                 "Why did you choose this particular programme and how does it align with the core aims and values of your organisation?" do
          classes "sub-question"
          required
          ref "B 2.1"
          rows 5
          words_max 250
        end

        textarea :targeted_disadvantaged_groups, "Which disadvantaged group(s) is your programme targeted towards?" do
          classes "sub-question"
          required
          ref "B 2.2.1"
          rows 5
          words_max 50
        end

        textarea :targeted_disadvantaged_groups_benefits, "What does your programme provide to your target group(s)?" do
          classes "sub-question"
          required
          ref "B 2.2.2"
          rows 5
          words_max 100
        end

        textarea :programme_befinits_to_regular_operations, "How does your programme benefit your usual day to day operations?" do
          classes "sub-question"
          required
          ref "B 2.2.3"
          rows 5
          words_max 100
        end

        textarea :measurement_of_success,
                 "How do you measure the success of your programme? What has the programme achieved for your targeted group(s)?" do
          classes "sub-question"
          required
          ref "B 2.2.4"
          rows 5
          words_max 250
        end

        textarea :investments_return_prediction,
                 "How do you ensure that the programme provides a good return for your organisation, financially or otherwise?" do
          ref "B 3"
          required
          context %(
            <p>How much time, effort or money is invested in the programme - consider financial, human resource and in-kind investments? How does the scale of this investment compare with wider talent management activities?</p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_return_responsibility,
                 "Who is ultimately responsible for the return from the programme? Who is responsible for the day-to-day management of the programme?" do
          classes "sub-question"
          sub_ref "B 3.1"
          required
          context %(
            <p>
              You may include chart(s) to make it easier for assessors to understand how your programme is managed in section E.
            </p>
          )
          rows 5
          words_max 150
        end

        textarea :programme_kpis,
                 "What are the goals of the programme? What Key Performance Indicators (KPIs) are used to measure progress? How are they set and monitored? Are the KPIs being met and what happens if they are not met?" do
          classes "sub-question"
          sub_ref "B 3.2"
          context %(
            <p>What impact did you set out to achieve with the programme regarding your objectives and KPIs?</p>
            <p>State what quantifiable measures were used to evaluate the success of the programme to your organisation, employees or others in meeting objectives for performance.</p>
          )
          required
          rows 5
          words_max 400
        end

        textarea :programme_benefit_evidence, "Provide evidence on how the programme benefits disadvantaged people." do
          ref "B 4"
          required
          context %(
            <p>
             You should demonstrate positive impacts in <strong>at least two</strong> of the following areas:
            </p>
            <ul>
              <li>
                <strong>Accessible routes</strong> - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.
              </li>
              <li>
                <strong>Careers advice</strong> – provide careers advice or information to help people make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.
              <li>
                <strong>Work placements</strong> - preparing people for the world of work through inspiring work experiences and internships.
              </li>
              <li>
                <strong>Fairer recruitment</strong> - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - social-economic or academic. For example, by removing applicant’s name or school names from CVs, providing unconscious bias training for recruitment assessors.
              </li>
              <li>
                <strong>Early careers</strong> - fostering a ‘youth-friendly’ culture in your workplace where young employees from disadvantaged backgrounds are invested in and developed to progress in their careers.
              </li>
              <li>
                <strong>Advancement</strong> - developing career paths to senior positions that are open to all and track the progress of employees from non-graduate routes.
              </li>
              <li>
                <strong>Advocacy and leadership</strong> - demonstrate strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.
              </li>
            </ul>
            <p>
              Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence to support your application.
            </p>
            <p>
              Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
          )

          pdf_context %(
            <p>
             You should demonstrate positive impacts in <strong>at least two</strong> of the following areas:
            </p>
            <p>
              \u2022 Accessible routes - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.

              \u2022 Careers advice – provide careers advice or information to help people make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.

              \u2022 Work placements - preparing people for the world of work through inspiring work experiences and internships.

              \u2022 Fairer recruitment - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - social-economic or academic. For example, by removing applicant’s name or school names from CVs, providing unconscious bias training for recruitment assessors.

              \u2022 Early careers - fostering a ‘youth-friendly’ culture in your workplace where young employees from disadvantaged backgrounds are invested in and developed to progress in their careers.

              \u2022 Advancement - developing career paths to senior positions that are open to all and track the progress of employees from non-graduate routes.

              \u2022 Advocacy and leadership - demonstrate strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.
            </p>
            <p>
              Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence to support your application.
            </p>
            <p>
              Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
          )
          rows 8
          words_max 700
        end

        textarea :employability_improvement_evidence,
                 "Provide evidence on how your organisation improved the employability of the people who engaged in your programme and how it has raised their career aspirations and confidence." do
          classes "sub-question"
          sub_ref "B 4.1"
          required
          context %(
            <p>
              Improvements in employability could be as a result of teaching skills such as leadership, communications, team-work, resilience.
            </p>
            <p>
              If possible, use a balance of quantitative (for example, numbers, figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
            <p>
              Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.

            </p>
          )
          rows 5
          words_max 500
        end

        textarea :programme_integration,
                 "Describe how the programme benefits the overall business strategy, and what is the senior decision makers’ commitment to the future growth of the programme." do
          ref "B 5"
          required
          context %(
            <p>Provide a vision of what your organisation wants to do as well as evidence of how you have gone about integrating the programme to date.</p>
          )
          rows 5
          words_max 250
        end

        textarea :benefits_communication,
                 "What mechanisms are in place to communicate the benefits of the programme to employees, key internal and external stakeholders, including the disadvantaged groups at which the programme is aimed?" do
          classes "sub-question"
          sub_ref "B 5.1"
          required
          context %(
            <p>
              You can include in your answer below or attach in section E: newsletters, quotes or similar material to bring to life exactly how you communicate the value of your programme.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :organisation_culture_fosters,
                 "Describe how your organisation’s culture fosters and supports the social mobility programme." do
          classes "sub-question"
          sub_ref "B 5.2"
          required
          rows 5
          words_max 250
        end

        textarea :financial_benefits_evidence, "Provide evidence on how the programme benefits your organisation." do
          ref "B 6"
          required
          context %(
            <p>
              If possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
            <p>
              You may find it helpful to articulate these benefits by describing before and after.
            </p>
            <p>
              <strong>Financial benefits</strong> may fall into two categories:
            </p>
            <ul>
              <li>
                Savings - reduced recruitment costs, increases in retention;
              </li>
              <li>
                Growth - increased sales, access to new clients or markets or the development of new products.
              </li>
            </ul>
            <p>
              <strong>Other benefits</strong> may be demonstrated in the following ways:
            </p>
            <ul>
              <li>
                Employee relations - improvements in employee motivation, well-being or satisfaction;
              </li>
              <li>
                Diversity - increased the ability to access and attract a wider talent pool;
              </li>
              <li>
                Reputation - increased positive perceptions of the organisation among key stakeholders – for example, customers and the media;
              </li>
              <li>
                Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration.
              </li>
            </ul>
            <p>
              How would your business be affected if this social mobility programme had never been introduced?
            </p>
            <p>
              The above are just examples - you can choose to demonstrate benefits in other areas.
            </p>
          )
          pdf_context %(
            <p>
              If possible, use a balance of quantitative (for example, numbers and figures)and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
            <p>
              You may find it helpful to articulate these benefits by describing before and after.
            </p>
            <p>
              Financial benefits may fall into two categories:
            </p>
            <p>
              \u2022 Savings - reduced recruitment costs, increases in retention;

              \u2022 Growth - increased sales, access to new clients or markets or the development of new products.
            </p>
            <p>
              Other benefits may be demonstrated in the following ways:
            </p>
            <p>
              \u2022 Employee relations - improvements in employee motivation, well-being or satisfaction;

              \u2022 Diversity - increased the ability to access and attract a wider talent pool;

              \u2022 Reputation - increased positive perceptions of the organisation among key stakeholders – for example, customers and the media;

              \u2022 Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration.
            </p>
            <p>
              How would your business be affected if this social mobility programme had never been introduced?
            </p>
            <p>
              The above are just examples - you can choose to demonstrate benefits in other areas.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :possible_development_without_the_programme,
                 "Provide an assessment of what would have happened to your organisation if you <strong>had not</strong> developed your social mobility programme." do
          ref "B 6.1"
          classes "sub-question"
          required
          context %(
            <p>Consider how your organisation would be different now or in the future if you <strong>had not</strong> created your social mobility programme. You might want to consider your relationships with key customers or suppliers or how you would have acquired staff members.</p>
          )
          rows 5
          words_max 250
        end

        textarea :long_term_plans_for_promoting_oportunities,
                 "What are your long-term plans for ensuring your organisation continues to promote opportunities for those from disadvantaged backgrounds, beyond any initiatives you already have in place?" do
          ref "B 6.2"
          classes "sub-question"
          required
          rows 5
          words_max 250
        end

        textarea :exemplary_evidence, "Provide evidence of what makes your social mobility programme exemplary." do
          ref "B 7"
          required
          context %(
            <p>
              For example, the programme may be exemplary because of:
            </p>
            <ul>
              <li>An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;</li>
              <li>Developing a unique or innovative social mobility programme;</li>
              <li>Forming effective partnerships with charities, schools or Jobcentres;</li>
              <li>Leading the way in your company by doing something that has never been done before.</li>
            </ul>
            <p>
              The above are just examples - you can describe other reasons if more suitable.
            </p>
            <p>
              If possible, use a balance of quantitative (for example numbers, figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
          )
          pdf_context %(
            <p>
              For example, the programme may be exemplary as a result of:
            </p>
            <p>
              \u2022 An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;

              \u2022 Developing a unique or innovative social mobility programme;

              \u2022 Forming effective partnerships with charities, schools or Jobcentres;

              \u2022 Leading the way in your company by doing something that has never been done before.
            </p>
            <p>
              The above are just examples - you can describe other reasons if more suitable.
            </p>
            <p>
              If possible, use a balance of quantitative (for example numbers, figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
          )
          rows 8
          words_max 800
        end
      end
    end
  end
end
