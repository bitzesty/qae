# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :mobility_b_section_header, "" do
          context %(
            <p>
              This section gives you the opportunity to present the detail of your social mobility programme and to give us the evidence on how your programme benefits the people and your organisation that will enable us to assess your application.
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
            <p>Select all that apply.</p>
          )
          check_options [
            ["mentoring", "A programme which provides careers advice, skills development or mentoring that prepare young people for the world of work and/or accessible structured work experience."],
            ["career_opportunities_accessibility", "A programme which makes career opportunities more accessible by offering non-graduate routes such as traineeships or apprenticeships, or by reforming recruitment practices."],
            ["workplace_fostering", "A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers."]
          ]
        end

        regions :programme_regions, "In which regions does your programme have an impact?" do
          classes "sub-question"
          sub_ref "B 1.1"
          required
          context %(
            <p>Select all that apply.</p>
          )
        end

        textarea :mobility_desc_long, "Summarise your social mobility programme(s)." do
          classes "sub-question"
          sub_ref "B 1.2"
          required
          context %(
            <p>
              This is to help us understand the essence of your programme(s). The summary might be used in publicity material if your application is successful.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :mobility_desc_short, "Briefly describe your social mobility programme(s)." do
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

        textarea :provide_ceo_quote, "Provide a quote from the CEO that demonstrates support for the social mobility programme(s)." do
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

        textarea :business_cause, "What was the business case that motivated your organisation to provide the programme(s)?  What was the situation before the inception of this programme(s)?" do
          required
          ref "B 2"
          rows 5
          words_max 250
        end

        textarea :programme_cause, "Why did you choose this particular programme and how does it align with the core aims and values of your organisation?" do
          classes "sub-question"
          required
          ref "B 2.1"
          rows 5
          words_max 250
        end

        textarea :objectives_and_kpis, "What impact did you set out to achieve with the programme in terms of your objectives and KPIs?" do
          classes "sub-question"
          required
          sub_ref "B 2.2"
          rows 5
          words_max 250
        end

        textarea :investments_return_prediction, "How do you ensure that the programme(s) provides a good return on investment for your organisation?" do
          ref "B 3"
          required
          context %(
            <p>
              How much is invested in the programme(s) - consider financial, human resource and in-kind investments? How does the scale of this investment compare with wider talent management activities?
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_return_responsibility, "Who is ultimately responsible for the return on the investment from the programme?  What is the management structure to ensure the day-to-day management of programme(s) from board level down?" do
          classes "sub-question"
          sub_ref "B 3.1"
          required
          context %(
            <p>
              You may include chart(s) to make it easier for assessors to understand how your programme(s) is managed in section E.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :programme_kpis, "What are the KPIs related to the programme(s), how are they set and monitored? Are the KPIs being met and what happens if they are not met?" do
          classes "sub-question"
          sub_ref "B 3.2"
          required
          rows 5
          words_max 250
        end

        textarea :programme_integration, "Describe how the programme is integrated into the overall business strategy, and what is the board level commitment to the future growth of the programme(s)." do
          ref "B 4"
          required
          rows 5
          words_max 250
        end

        textarea :benefits_communication, "What mechanisms are in place to communicate the benefits of the programme(s) to key internal and external stakeholders?" do
          classes "sub-question"
          sub_ref "B 4.1"
          required
          context %(
            <p>
              You can include, or attach in section E of the form, newsletters, quotes or similar material to bring to life exactly how you communicate the value of your programme(s)
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :organisation_culture_fosters, "Describe how your organisation’s culture fosters and supports the social mobility programme(s)." do
          classes "sub-question"
          sub_ref "B 4.2"
          required
          rows 5
          words_max 250
        end

        textarea :programme_benefit_evidence, "Provide evidence on how does the programme(s) benefit people." do
          ref "B 5"
          required
          context %(
            <p>
             You should demonstrate positive impacts in at least two of the following areas:
            </p>
            <ul>
              <li>
                Careers advice - helping people to make more informed choices by providing careers advice or information
              </li>
              <li>
                Work placements - preparing people for the world of work through inspiring work experiences
              <li>
                Fairer recruitment - making your recruitment process fairer and more focused on attitude and aptitude
              </li>
              <li>
                Accessible routes - broadening access to your job opportunities by creating accessible routes to employment - e.g. jobs for school leavers, quality traineeships or apprenticeships, graduate schemes
              </li>
              <li>
                Early careers -  fostering a ‘youth-friendly’ culture in your workplace where young employees are invested in and developed to progress in their careers
              </li>
              <li>
                Advancement - developing career paths to senior positions that are open to all
              </li>
            </ul>
            <p>
              If possible, use a balance of quantitative (numbers, figures etc.) and qualitative (comments, feedback from people, key stakeholders etc.) evidence.
            </p>
            <p>
              Focus on what impact your activities have achieved to date, but include the longer term outcomes as well.
            </p>
          )
          rows 8
          words_max 700
        end

        textarea :employability_improvement_evidence, "Provide evidence on how your organisation improved the employability of your people and how it has raised their career aspirations and confidence." do
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

        textarea :financial_benefits_evidence, "Provide evidence on how the programme(s) benefits your organisation financially." do
          ref "B 6"
          required
          context %(
            <p>
              Financial benefits may fall under two categories:
            </p>
            <ul>
              <li>Savings - reduced recruitment costs, increases in retention.</li>
              <li>Growth -  increased sales, access to new clients or markets or the development of new products</li>
            </ul>
            <p>
              If possible, use a balance of quantitative (numbers, figures, etc.) and qualitative (comments, feedback from people, key stakeholders, etc.) evidence.
            </p>
            <p>
              You may find it helpful to articulate these benefits in terms of ‘before and after’.
            </p>

          )
          rows 5
          words_max 500
        end

        textarea :non_financial_benefits_evidence, "Provide evidence on how the programme(s) benefits your organisation in ways other than financial." do
          classes "sub-question"
          sub_ref "B 6.1"
          required
          context %(
            <p>
             For example, you may wish to demonstrate benefits in the following areas:
            </p>
            <ul>
              <li>
                Employee relations - improvements in employee motivation, well-being or satisfaction
              </li>
              <li>
                Diversity - increased ability to access and attract a wider talent pool
              <li>
                Reputation -  increased positive perceptions of the organisation among key stakeholders - e.g. customers and the media
              </li>
              <li>
                Collaboration -  best practices and learnings fed-back into other departments; increased cross-departmental collaboration
              </li>
            </ul>
            <p>
              The above are just examples - you can choose to demonstrate benefits in any other areas.
            </p>
            <p>
              If possible, use a balance of quantitative (numbers, figures etc.) and qualitative (comments, feedback from people, key stakeholders etc.) evidence.
            </p>
            <p>
              You may find it helpful to articulate these benefits in terms of ‘before and after’.
            </p>
          )
          rows 8
          words_max 500
        end

        textarea :exemplary_evidence, "Provide evidence on what makes your social mobility programme(s) exemplary?" do
          ref "B 7"
          required
          context %(
            <p>
              For example, the programme may be exemplary as a result of:
            </p>
            <ul>
              <li> An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people.</li>
              <li>Developing a unique or innovative social mobility programme.</li>
              <li>Forming effective partnerships with charities, schools or Jobcentres.</li>
              <li>Leading the way in your company by doing something that has never been done before.</li>
            </ul>
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
