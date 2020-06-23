# -*- coding: utf-8 -*-
class AwardYears::V2021::QAEForms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :mobility_b_section_header, "" do
          context %(
            <h3>About this section</h3>

            <p>This section enables you to present the details of how your organisation has made a difference by promoting opportunity through social mobility. This may have been as a core aim of your organisation or achieved via a social mobility initiative. Your answers will provide us with evidence on how this benefits the participants, your organisation and wider society.</p>

            <h3>Definition of Social Mobility</h3>

            <p>Social mobility is a measure of the ability to move from a lower socio-economic background to a higher socio-economic status.</p>
            <ul>
              <li>Socio-economic background is a set of social and economic circumstances from which a person has come.</li>
              <li>Socio-economic status is a person's current social and economic circumstances.</li>
            </ul>

            <p>We classify people as being from a lower or higher socio-economic background based on these variables:</p>

            <ul>
              <li><a target="_blank" href="https://en.wikipedia.org/wiki/National_Statistics_Socio-economic_Classification">The National Statistics Socio-economic classification (NS-SEC)</a> of parent's occupation. This is based on the type of job the main or highest income earner in the household had as their main job when the person was 14.</li>
              <li>Whether they were receiving free school meals or access pupil premium funding.</li>
              <li>The highest level of qualifications achieved by either parent(s) or guardian(s) by the time the person was 18.</li>
              <li>The type of school the person attended.</li>
            </ul>

            <h3>Overarching criteria</h3>

            <p>We are looking to recognise:</p>

            <ol type="a">
              <li>
                <p>Initiatives that promote opportunity through social mobility. These initiatives should be structured and designed to target and support people from disadvantaged backgrounds.</p><br/>

                <p>Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.</p><br/>

                <p>It does not have to be large if your organisation is small - we will evaluate it in proportion to the organisation’s size. However, it has to be structured.</p><br/>

                <p>For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain percentage of recruits to come from disadvantaged backgrounds.</p><br/>

                <p>If your organisation has more than one initiative that meets the criteria for the award, please submit separate applications for each initiative.</p><br/>

                <p>If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim.</p><br/>
              </li>

              <li>
                <p>Organisations whose core day-to-day aim is to promote opportunity through social mobility; These organisations exist purely to support people from disadvantaged backgrounds.</p>
              </li>
            </ol>

            <h3>Evidence</h3>

            <p>Applicants need to provide quantifiable evidence to support the claims made. This should be from the numbers presented, third-party evaluations and feedback received from those who have received support.</p>

            <p>When providing quantitative evidence, provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.</p>

            <p>When considering qualitative evidence, where possible, provide a range of examples.</p>

            <p>In the case of feedback, it needs to be an analysis of any scores or ratings, including positive, negative and neutral feedback. Ad-hoc quotes and anecdotal feedback will strengthen your application but are not sufficient on their own.</p>

            <h3>Small organisations</h3>

            <p>The Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is a reasonable performance, given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.</p>

            <h3>Answering questions</h3>

            <p>Please try to avoid using technical jargon in this section. If you use acronyms, these should be explained clearly in the first instance.</p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              This section enables you to present the details of your social mobility programme and to give us the evidence on how your programme benefits your staff and your organisation.
            )],
            [:bold, "Definition of Social Mobility"],
            [:normal, %(
              Social mobility is a measure of the ability to move from lower socio-economic background to higher socio-economic status.

              Socio-economic background is a set of social and economic circumstances from which a person has come. Socio-economic status is a person's current social and economic circumstances.

              We classify people as being from a lower or higher socio-economic background based on these variables:

              \u2022 The National Statistics Socio-economic classification (NS-SEC) of parent's occupation.

              \u2022 This is based on the type of job the main or highest income earner in the household had as their main job when the person was 14.

              \u2022 Whether they were receiving free school meals.

              \u2022 The highest level of qualifications achieved by either parent(s) or guardian(s) by the time the person was 18.

              \u2022 The type of school the person attended.
            )],
            [:bold, "Qualifying programmes"],
            [:normal, %(
              You should demonstrate positive impacts in at least one of the following:

              \u2022 A programme which provides careers advice, skills development or mentoring that prepare young people from disadvantaged or lower socio-economic backgrounds for the world of work or accessible, structured work experience.

              \u2022 A programme which makes career opportunities more accessible by offering non-graduate routes such as well-structured traineeships, apprenticeships or internships, or by reforming recruitment practices and offering clear paths for progression.

              \u2022 A programme which fosters workplaces where employees have equal access to ongoing support and progression opportunities to further their careers and champions a culture of inclusiveness at every level.

              Please note, a programme could be an initiative, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach programmes.
            )],
            [:bold, "Types of activities"],
            [:normal, %(
              When considering positive impacts, the following may help in clarifying what we are looking for in your application:

              \u2022 Accessible routes - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.

              \u2022 Careers advice – provide careers advice or information to help people make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.

              \u2022 Work placements - preparing people for the world of work through inspiring work experiences and internships.

              \u2022 Fairer recruitment - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - social-economic or academic. For example, by removing applicants’ names or school names from CVs, providing unconscious bias training for recruitment assessors.

              \u2022 Early careers - fostering a ‘youth-friendly’ culture in your workplace where young employees from disadvantaged backgrounds are invested in and developed to progress in their careers.

              \u2022 Advancement - developing career paths to senior positions that are open to all and track the progress of employees from non-graduate routes.

              \u2022 Advocacy and leadership - demonstrate strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.
            )],
            [:bold, "Overarching criteria"],
            [:normal, %(
              Please note, we are looking to recognise those who are going above and beyond their core day-to-day business, acting to improve social mobility within their company locally or nationally, accessing and retaining talent regardless of socio-economic background.

              An award is unlikely to be granted to a social enterprise, learning provider or charity whose main purpose is to deliver social mobility programmes either for itself or on behalf of other organisations. This is because we are seeking to reward and encourage companies to address social mobility challenges within their organisations, even though this is not their sole objective.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],
            [:bold, "Answering questions"],
            [:normal, %(
              If you have more than one social mobility programme, please provide details.
              Please try to avoid using technical jargon in this section.
            )]
          ]
        end

        textarea :your_social_mobility_programme, "Your social mobility programme" do
          ref "B 1"
          required
          context %{
            <p>
              Please summarise your social mobility programme. This is to help us understand the essence of your programme. The summary might be used in publicity material if your application is successful.
            </p>
            <p>
              Please include:
            </p>
            <p>
              a) The aims of the programme.
            </p>
            <p>
              b) Which disadvantaged group(s) is your programme targeted towards?
            </p>
            <p>
              c) the proportion of those on the programme which come from disadvantaged backgrounds. If you are offering work placements or work experience, include statistics on what percentage of those people then go on into full-time employment, either within your company or the sector.
            </p>
            <p>
              d) What does your programme provide to your target group(s)?
            </p>
            <p>
              e) Provide evidence of what makes your social mobility programme exemplary. For example, the programme may be exemplary as a result of:
            </p>
            <ul>
              <li>An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;</li>
              <li>Developing a unique or innovative social mobility programme;</li>
              <li>Forming effective partnerships with charities, schools or Jobcentres or Local Enterprise Partnerships;</li>
              <li>Leading the way in your company by doing something that has never been done before.</li>
            </ul>
          }

          pdf_context %{
            <p>
              Please summarise your social mobility programme. This is to help us understand the essence of your programme. The summary might be used in publicity material if your application is successful.
            </p>
            <p>
              Please include:

              a) The aims of the programme.

              b) Which disadvantaged group(s) is your programme targeted towards?

              c) the proportion of those on the programme which come from disadvantaged backgrounds. If you are offering work placements or work experience, include statistics on what percentage of those people then go on into full-time employment, either within your company or the sector.

              d) What does your programme provide to your target group(s)?

              e) Provide evidence of what makes your social mobility programme exemplary. For example, the programme may be exemplary as a result of:

              \u2022 An exemplary overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit and develop people;

              \u2022 Developing a unique or innovative social mobility programme;

              \u2022 Forming effective partnerships with charities, schools or Jobcentres or Local Enterprise Partnerships;

              \u2022 Leading the way in your company by doing something that has never been done before.
            </p>
          }
          rows 10
          words_max 1000
        end

        textarea :mobility_desc_short, "Provide a one-line description of your social mobility programme." do
          classes "sub-question"
          sub_ref "B 1.2"
          required
          context %(
            <p>
              This description will be used in publicity material if your application is successful.
            </p>
          )
          words_max 15
        end

        textarea :your_core_business, "Your core business" do
          ref "B 2"
          required
          context %{
            <p>
              Briefly describe your core business and what factors or issues motivated your organisation to provide the programme.
            </p>
            <p>
              Please include details on:
            </p>
            <p>
              a) What was the situation before the inception of this programme?
            </p>
            <p>
              b) Why did you choose this particular programme and how does it align with the core aims and values of your organisation?
            </p>
            <p>
              c) The impact on your employees, region(s) and communities.
            </p>
          }

          pdf_context %{
            <p>
              Briefly describe your core business and what factors or issues motivated your organisation to provide the programme.

              Please include details on:

              a) What was the situation before the inception of this programme?

              b) Why did you choose this particular programme and how does it align with the core aims and values of your organisation?

              c) The impact on your employees, region(s) and communities.
            </p>
          }
          rows 5
          words_max 250
        end

        textarea :impact_of_your_programme, "Impact of your programme" do
          ref "B 3"
          required
          context %{
            <p>
              Please describe the impact of your programme.

              Where possible please include:
            </p>
            <p>
              a) How you measure the success of your programme? For example, are key performance indicators (KPIs) used? If so, how are they set and monitored? Are the KPIs
            being met and what happens if they are not?
            </p>
            <p>
              b) State what quantifiable measures were used to evaluate the success of the programme
            to your organisation, employees or others in meeting objectives for performance. Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence to support your application. Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
            <p>
              c) What has the programme achieved for your targeted group(s)?
            </p>
            <p>
              d) How does your programme benefit your usual day to day operations?
            </p>
            <p>
              e) How does the scale of this programme compare with wider talent management activities?
            </p>
            <p>
              f) Who is ultimately responsible for the programme’s success?
            </p>
            <p>
              g) Who is responsible for the day-to-day management of the programme?
            </p>
            <p>
              You may include chart(s) to make it easier for assessors to understand how your programme is managed in section E.
            </p>
          }

          pdf_context %{
            <p>
              Please describe the impact of your programme.

              Where possible please include:

              a) How you measure the success of your programme? For example, are key performance indicators (KPIs) used? If so, how are they set and monitored? Are the KPIs being met and what happens if they are not?

              b) State what quantifiable measures were used to evaluate the success of the programme to your organisation, employees or others in meeting objectives for performance. Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence to support your application. Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.

              c) What has the programme achieved for your targeted group(s)?

              d) How does your programme benefit your usual day to day operations?

              e) How does the scale of this programme compare with wider talent management activities?

              f) Who is ultimately responsible for the programme’s success?

              g) Who is responsible for the day-to-day management of the programme?

              You may include chart(s) to make it easier for assessors to understand how your programme is managed in section E.
            </p>
          }
          rows 10
          words_max 1000
        end

        textarea :impact_on_programme_participants, "Impact on programme participants" do
          ref "B 4"
          required
          context %{
            <p>
              Please provide evidence on how your organisation improved the employability of the people who engaged in your programme and how it has raised their career aspirations and confidence. Improvements in employability could be as a result of teaching skills such as leadership, communication, team-work, resilience.
            </p>
            <p>
            <p>
              If possible, use a balance of quantitative (for example, numbers, figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.
            </p>
            <p>
              Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
            <p>
              Include the impact of the programme on the local community and at a regional and national level.
            </p>
          }

          pdf_context %{
            <p>
              Please provide evidence on how your organisation improved the employability of the people who engaged in your programme and how it has raised their career aspirations and confidence. Improvements in employability could be as a result of teaching skills such as leadership, communication, team-work, resilience.

              If possible, use a balance of quantitative (for example, numbers, figures) and qualitative (for example, comments, feedback from people, key stakeholders) evidence.

              Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.

              Include the impact of the programme on the local community and at a regional and national level.
            </p>
          }
          rows 10
          words_max 1000
        end

        textarea :your_organisations_culture_regarding_social_mobility, "Your organisation’s culture regarding social mobility" do
          ref "B 5"
          required
          context %{
            <p>
              Describe how your organisation’s culture fosters and supports social mobility.
            </p>
            <p>
              Please include:
            </p>
            <p>
              a) How the programme benefits the overall business strategy, and what is the senior decision makers’ commitment to the future growth of the programme.
            </p>
            <p>
              b) A vision of what your organisation wants to do as well as evidence of how you have gone about integrating the programme in your organisation and with stakeholders.
            </p>
            <p>
              c) What mechanisms are in place to communicate the benefits of the programme to employees, key internal and external stakeholders, including the disadvantaged groups at which the programme is aimed? You can include in your answer below or attach in section E: newsletters, quotes or similar material to bring to life exactly how you communicate the value of your programme.
            </p>
            <p>
              d) Other benefits such as:
            </p>
            <ul>
              <li><strong>Employee relations</strong> - improvements in employee motivation, well-being or satisfaction;</li>
              <li><strong>Diversity</strong> - increased the ability to access and attract a wider talent pool;</li>
              <li><strong>Reputation</strong> - increased positive perceptions of the organisation among key stakeholders - for example, customers and the media;</li>
              <li><strong>Collaboration</strong> - best practices and learnings fed-back into other departments; increased cross-departmental collaboration.</li>
            </ul>
            <p>
              e) What are your long-term plans for ensuring your organisation continues to promote opportunities for those from disadvantaged backgrounds, beyond any initiatives you already have in place?
            </p>
          }

          pdf_context %{
            <p>
              Describe how your organisation’s culture fosters and supports social mobility.

              Please include:

              a) How the programme benefits the overall business strategy, and what is the senior decision makers’ commitment to the future growth of the programme.

              b) A vision of what your organisation wants to do as well as evidence of how you have gone about integrating the programme in your organisation and with stakeholders.

              c) What mechanisms are in place to communicate the benefits of the programme to employees, key internal and external stakeholders, including the disadvantaged groups at which the programme is aimed? You can include in your answer below or attach in section E: newsletters, quotes or similar material to bring to life exactly how you communicate the value of your programme.

              d) Other benefits such as:

              \u2022 Employee relations - improvements in employee motivation, well-being or satisfaction;
              \u2022 Diversity - increased the ability to access and attract a wider talent pool;
              \u2022 Reputation - increased positive perceptions of the organisation among key stakeholders - for example, customers and the media;
              \u2022 Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration.

              e) What are your long-term plans for ensuring your organisation continues to promote opportunities for those from disadvantaged backgrounds, beyond any initiatives you already have in place?
            </p>
          }
          rows 5
          words_max 250
        end
      end
    end
  end
end
