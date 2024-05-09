class AwardYears::V2021::QaeForms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :mobility_b_section_header, "" do
          context %(
            <h3>About this section</h3>

            <p>This section enables you to present the details of how your organisation has made a difference by promoting opportunity through social mobility. This may have been as a core aim of your organisation or achieved via a social mobility initiative <strong>for at least two years</strong>. Your answers will provide us with evidence on how this benefits the participants, your organisation and wider society.</p>

            <h3>Social mobility definition</h3>

            <p>Social mobility is a measure of the ability to move from a lower socio-economic background to higher socio-economic status.</p>
            <ul>
              <li>Socio-economic background is a set of social and economic circumstances from which a person has come.</li>
              <li>Socio-economic status is a person's current social and economic circumstances.</li>
            </ul>

            <h3>Disadvantaged groups that Queens’ Awards for Enterprise focuses on</h3>
            <p>For the purpose of this award, we classify people as being from a lower socio-economic background if they come from one of the below listed disadvantaged backgrounds:</p>

            <ul>
              <li>People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;</li>
              <li>Asylum seekers and refugees or children of refugees;</li>
              <li>Young people (over 16 years old) with English as a second language;</li>
              <li>Long-term unemployed or people who grew up in workless households;</li>
              <li>People on low incomes;</li>
              <li>Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;</li>
              <li>People who received free school meals or if there are children in the person’s current household who receive free school meals;</li>
              <li>Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;</li>
              <li>Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;</li>
              <li>Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;</li>
              <li>People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;</li>
              <li>People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;</li>
              <li>People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;</li>
              <li>People recovering or who have recovered from addiction;</li>
              <li>Survivors of domestic violence;</li>
              <li>Military veterans;</li>
              <li>Ex-offenders;</li>
              <li>Families of prisoners.</li>
            </ul>

            <p>Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement.</p>

            <h3>Evidence</h3>

            <p>Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.</p>

            <p>The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.</p>

            <h3>Small organisations</h3>

            <p>The Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.</p>

            <h3>Answering questions</h3>

            <p>Please try to avoid using technical jargon in this section. If you use acronyms, these should be explained clearly in the first instance.</p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              This section enables you to present the details of how your organisation has made a difference by promoting opportunity through social mobility. This may have been as a core aim of your organisation or achieved via a social mobility initiative <strong>for at least two years</strong>. Your answers will provide us with evidence on how this benefits the participants, your organisation and wider society.
            )],

            [:bold, "Social mobility definition"],
            [:normal, %(
              Social mobility is a measure of the ability to move from a lower socio-economic background to higher socio-economic status.

              \u2022 Socio-economic background is a set of social and economic circumstances from which a person has come.

              \u2022 Socio-economic status is a person's current social and economic circumstances.)],
            [:bold, "Disadvantaged groups that Queens’ Awards for Enterprise focuses on"],
            [:normal, %(
              For the purpose of this award, we classify people as being from a lower socio-economic background if they come from one of the below listed disadvantaged backgrounds:

              \u2022 People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;

              \u2022 Asylum seekers and refugees or children of refugees;

              \u2022 Young people (over 16 years old) with English as a second language;

              \u2022 Long-term unemployed or people who grew up in workless households;

              \u2022 People on low incomes;

              \u2022 Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;

              \u2022 People who received free school meals or if there are children in the person’s current household who receive free school meals;

              \u2022 Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;

              \u2022 Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;

              \u2022 Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;

              \u2022 People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;

              \u2022 People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;

              \u2022 People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;

              \u2022 People recovering or who have recovered from addiction;

              \u2022 Survivors of domestic violence;

              \u2022 Military veterans;

              \u2022 Ex-offenders;

              \u2022 Families of prisoners.

              Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement.
            )],

            [:bold, "Evidence"],
            [:normal, %(
              Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.

              The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.
            )],

            [:bold, "Small organisations"],
            [:normal, %(
              The Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],

            [:bold, "Answering questions"],
            [:normal, %(
              Please try to avoid using technical jargon in this section. If you use acronyms, these should be explained clearly in the first instance.
            )],
          ]
        end

        options :application_category, "Application category" do
          required
          ref "B 1"
          context %(
            <p>
              Select whether your application is for:
            </p>
          )
          option "initiative", "a) <strong>An initiative</strong> which promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds."
          option "organisation", "b) <strong>A whole organisation</strong> whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."

          context_for_option "initiative", "Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.<br/><br/>
            For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.<br/><br/>
            If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim. <br/><br/>
            If your organisation has more than one initiative that meets the criteria for the award, please submit separate applications for each initiative."


          context_for_option "organisation", "For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects."

          pdf_context_for_option "initiative", [
            [:normal, "Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.\n"],

            [:normal, "For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.\n"],
            [:normal, "If your application is for an initiative, promoting opportunity through social mobility does not have to be your organisation's core aim."],
            [:normal, "If your organisation has more than one initiative that meets the criteria for the award, please submit separate applications for each initiative.\n"],

            [:italic, "(If you selected this option, answer all B2a, B3a, B4a, B5a, B6a, B7a, B8a questions)"],
          ]

          pdf_context_for_option "organisation", [

            [:normal, "For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects.\n"],
            [:italic, "(If you selected this option, answer all B2b, B3b, B4b, B5b, B6b, B7b questions)"],
          ]

          default_option "initiative"
        end

        # INITIATIVE QUESTIONS START HERE

        comment :initiative_question_guidance, "" do
          pdf_context_with_header_blocks [
            [:italic, "Answer the questions below if you selected option (a) in question B1 - your application is for an initiative that promotes opportunity through social mobility."],
          ]
        end

        checkbox_seria :initiative_activities, "What type of activities does your initiative focus on to make a positive impact by promoting opportunity through social mobility?" do
          ref "B 2a"
          required
          classes "question-limited-selections"
          selection_limit 3
          context %(
            <p>If necessary, you can select more than one activity, but no more than three. If you feel that more than three activities are applicable, select the three that the initiative focuses on most.</p>
          )
          check_options [
            ["careers_advice", "<strong>Careers advice</strong> - providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes."],
            ["fairer_recruitment", "<strong>Fairer recruitment</strong> - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - socio-economic or academic."],
            ["skills_development", "<strong>Skills development</strong> - providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may include the development of aspirations and increasing motivation."],
            ["work_placements", "<strong>Work placements</strong> - preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships."],
            ["early_careers", "<strong>Early careers</strong> - fostering a youth-friendly culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers."],
            ["job_opportunities", "<strong>Job opportunities</strong> - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes."],
            ["advancement", "<strong>Advancement</strong> - developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes."],
            ["advocacy_and_leadership", "<strong>Advocacy and leadership</strong> - demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility."],
          ]
          conditional :application_category, "initiative"
        end

        header :initiative_header_b3a, "Summary of your promoting opportunity through social mobility initiative." do
          ref "B 3a"
          conditional :application_category, "initiative"
        end

        textarea :initiative_desc_short, "Provide a one-line description of your initiative." do
          classes "sub-question"
          sub_ref "B 3.1a"
          required
          context %(
            <p>This description will be used in publicity material if your application is successful.</p>
          )
          words_max 15
          conditional :application_category, "initiative"
        end

        textarea :initiative_desc_medium, "Briefly describe the initiative, its aims, what it provides and how it promotes opportunity through social mobility." do
          classes "sub-question"
          sub_ref "B 3.2a"
          required
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :initiative_motivations, "Outline the factors or issues that motivated your organisation to provide the initiative." do
          classes "sub-question"
          sub_ref "B 3.3a"
          required
          context %(
            <p>Please include details on:</p>

            <p>1. When was the initiative started?</p>

            <p>2. What was the situation before the inception of this initiative? Please include details on what the issues or needs of the potential participants were.</p>

            <p>3. Why did you choose this particular initiative?</p>

            <p>4. How does this initiative align with the core aims and values of your organisation?</p>
          )
          words_max 500
          conditional :application_category, "initiative"
        end

        textarea :initiative_exemplary_evidence, "Provide evidence of what makes the initiative exemplary." do
          classes "sub-question"
          sub_ref "B 3.4a"
          required
          context %(
            <p>Taking into account your mission, values and strategic objectives, provide evidence of how and why your initiative stands out from others to promote opportunity through social mobility to disadvantaged groups.</p>

            <p>For example, you may feel your approach to bringing key people together and how you have created, improved and influenced your initiative sets you apart from your peers. If you have led the way by doing something that has never been done before, please provide evidence on what you did and how you did this.</p>

            <p>Your initiative may be exemplary as a result of a strategy to inform, guide, recruit and develop people or you may have formed effective partnerships and collaborations with organisations, bringing them together to support diversity and inclusion. It is important to provide evidence on how you did this.</p>

            <p>Highlight if your initiative has two-fold benefits – it helps the participants by addressing the socio-economic barriers to employment as well as having a positive impact across the whole organisation.</p>
          )
          words_max 500
          conditional :application_category, "initiative"
        end

        header :initiative_header_b4a, "Measuring success" do
          ref "B 4a"
          context %(
            <p>The questions in B4 are not about the actual output or outcomes, but rather the targets you set and how you go about measuring outputs and outcomes against them.</p>
          )
          conditional :application_category, "initiative"
        end

        textarea :initiative_day_to_day_running, "Who is responsible for, and who runs the initiative day-to-day?" do
          classes "sub-question"
          sub_ref "B 4.1a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :initiative_measuring_targets, "Describe what key performance indicators (KPIs) or equivalent targets you set and how you monitor them in the context of your initiative." do
          classes "sub-question"
          sub_ref "B 4.2a"
          required
          context %(
            <ul>
              <li>Provide information on what targets you set for your initiative.</li>
              <li>Explain how you monitor performance against the target.</li>
              <li>Explain what evidence you gather to show short and longer-term outcomes - this may include but is not limited to - internal records, third party evidence, survey responses, interviews, ad-hoc feedback.</li>
            </ul>
          )
          pdf_context %(
            \u2022 Provide information on what targets you set for your initiative.

            \u2022 Explain how you monitor performance against the target.

            \u2022 Explain what evidence you gather to show short and longer-term outcomes - this may include but is not limited to - internal records, third party evidence, survey responses, interviews, ad-hoc feedback.
          )
          words_max 500
          conditional :application_category, "initiative"
        end

        textarea :initiative_targets_not_met, "Explain what happens if your initiative doesn't meet the KPIs or alternative performance targets?" do
          classes "sub-question"
          sub_ref "B 4.3a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        header :initiative_header_b5a, "The impact on participants." do
          ref "B 5a"
          conditional :application_category, "initiative"
        end

        textarea :initiative_disadvantaged_groups, "Describe which disadvantaged groups the initiative targets." do
          classes "sub-question"
          sub_ref "B 5.1a"
          required
          context %(
            <p>This award aims to recognise promoting opportunity through social mobility efforts that focus on the disadvantaged groups listed below:</p>
            <ul>
              <li>People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;</li>
              <li>Asylum seekers and refugees or children of refugees;</li>
              <li>Young people (over 16 years old) with English as a second language;</li>
              <li>Long-term unemployed or people who grew up in workless households;</li>
              <li>People on low incomes;</li>
              <li>Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;</li>
              <li>People who received free school meals or if there are children in the person’s current household who receive free school meals;</li>
              <li>Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;</li>
              <li>Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;</li>
              <li>Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;</li>
              <li>People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;</li>
              <li>People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;</li>
              <li>People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;</li>
              <li>People recovering or who have recovered from addiction;</li>
              <li>Survivors of domestic violence;</li>
              <li>Military veterans;</li>
              <li>Ex-offenders;</li>
              <li>Families of prisoners.</li>
            </ul>
            <p>Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement.</p>
            <p> Please provide the totals and year by year breakdown of:</p>
            <ol>
              <li>the total number of participants;</li>
              <li>the proportion of participants from disadvantaged backgrounds;</li>
              <li>the breakdown of these participants by disadvantaged group;</li>
              <li>for each disadvantaged group, specify the participant age range and in what UK counties they are based.</li>
            </ol>
            <p>Please provide aggregate numbers for all the years as well as year by year breakdown for at least the last two years. The breakdown will help us understand the output and outcome data in question B5.2.</p>
          )
          pdf_context %(
            This award aims to recognise promoting opportunity through social mobility efforts that focus on the disadvantaged groups listed below:

              \u2022 People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;

              \u2022 Asylum seekers and refugees or children of refugees;

              \u2022 Young people (over 16 years old) with English as a second language;

              \u2022 Long-term unemployed or people who grew up in workless households;

              \u2022 People on low incomes;

              \u2022 Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;

              \u2022 People who received free school meals or if there are children in the person’s current household who receive free school meals;

              \u2022 Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;

              \u2022 Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;

              \u2022 Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;

              \u2022 People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;

              \u2022 People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;

              \u2022 People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;

              \u2022 People recovering or who have recovered from addiction;

              \u2022 Survivors of domestic violence;

              \u2022 Military veterans;

              \u2022 Ex-offenders;

              \u2022 Families of prisoners.

              Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement.

              Please provide the totals and year by year breakdown of:

              1. the total number of participants;

              2. the proportion of participants from disadvantaged backgrounds;

              3. the breakdown of these participants by disadvantaged group;
              
              4. for each disadvantaged group, specify the participant age range and in what UK counties they are based.

              Please provide aggregate numbers for all the years as well as year by year breakdown for at least the last two years. The breakdown will help us understand the output and outcome data in question B5.2.
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :initiative_quantitative_evidence, "Provide quantitative evidence on the impact that your initiative has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.2a"
          required
          context %(
            <p>Provide <strong>quantitative data</strong> (for example, numbers, figures) that shows how your initiative has brought about meaningful change or improved the employability and sustainability of the participants.</p>
            <ul>
              <li>Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.</li>
              <li>Provide total figures of your overall impact over the years (minimum for the last two years).</li>
              <li>Provide year by year breakdown to demonstrate growth and improvement (minimum for the last two years).</li>
              <li>Include any <strong>output</strong> data. For example, a number of participants successfully completing a training course.</li>
              <li>Include any <strong>outcome</strong> data, including <strong>short-term</strong> and, where available, <strong>longer-term</strong> outcomes. For example, a number of participants who, after completing the course, gained employment and then how many of those are in employment after one year.</li>
              <li>Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.</li>
              <li>Explain where the data comes from - this may include, but is not limited to - internal records, third party evidence, survey responses.</li>
            </ul>
          )
          pdf_context %(
            Provide <strong>quantitative data</strong> (for example, numbers, figures) that shows how your initiative has brought about meaningful change or improved the employability and sustainability of the participants.

            \u2022 Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.

            \u2022 Provide total figures of your overall impact over the years (minimum for the last two years).

            \u2022 Provide year by year breakdown to demonstrate growth and improvement (minimum for the last two years).

            \u2022 Include any <strong>output</strong> data. For example, a number of participants successfully completing a training course.

            \u2022 Include any <strong>outcome</strong> data, including <strong>short-term</strong> and, where available, <strong>longer-term</strong> outcomes. For example, a number of participants who, after completing the course, gained employment and then how many of those are in employment after one year.

            \u2022 Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.

            \u2022 Explain where the data comes from - this may include, but is not limited to - internal records, third party evidence, survey responses.
          )
          words_max 750
          conditional :application_category, "initiative"
        end

        textarea :initiative_qualitative_evidence, "Provide qualitative evidence on the impact that your initiative has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.3a"
          required
          context %(
            <p>Provide <strong>qualitative data</strong> (for example, people’s stories as well as comments, feedback from participants and key stakeholders) that shows how your initiative has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.</p>
            <ul>
              <li>Include stories of impact on participants’ lives. If possible, provide a range of examples.</li>
              <li>Include feedback, such as quotes, that you have gathered from participants to understand how they have benefited.</li>
              <li>If applicable, include feedback that you have gathered from third-party stakeholders to understand how the participants have benefited. </li>
              <li>Explain where the information comes from - this may include, but is not limited to - surveys, interviews or ad-hoc feedback.</li>
            </ul>
          )
          pdf_context %(
            Provide qualitative data (for example, people’s stories as well as comments, feedback from participants and key stakeholders) that shows how your initiative has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.

            \u2022 Include stories of impact on participants’ lives. If possible, provide a range of examples.

            \u2022 Include feedback, such as quotes, that you have gathered from participants to understand how they have benefited.

            \u2022 If applicable, include feedback that you have gathered from third-party stakeholders to understand how the participants have benefited.

            \u2022 Explain where the information comes from - this may include, but is not limited to - surveys, interviews or ad-hoc feedback.
          )
          words_max 750
          conditional :application_category, "initiative"
        end

        textarea :initiative_feedback, "Describe what feedback, if any, you sought on how your initiative could be improved. What, if any, of the suggested improvements have you implemented?" do
          classes "sub-question"
          sub_ref "B 5.4a"
          required
          context %(
            <ul>
              <li>Explain how you sought feedback.</li>
              <li>Include a summary of the feedback gathered such as participant or third-party stakeholder quotes as well as quantitative data, for example, scores on how likely they are to recommend the organisation to their peers or similar ratings.</li>
              <li>Explain what, if any, of the suggested improvements have you implemented.</li>
            </ul>
          )
          pdf_context %(
            \u2022 Explain how you sought feedback.

            \u2022 Include a summary of the feedback gathered such as participant or third-party stakeholder quotes as well as quantitative data, for example, scores on how likely they are to recommend the organisation to their peers or similar ratings.

            \u2022 Explain what, if any, of the suggested improvements have you implemented.
          )
          words_max 250
          conditional :application_category, "initiative"
        end

        header :initiative_header_b6a, "Impact on your organisation." do
          ref "B 6a"
          conditional :application_category, "initiative"
        end

        textarea :initiative_impact_sharing, "Explain if and how you share and celebrate the evidence of the initiative’s impact across the organisation?" do
          classes "sub-question"
          sub_ref "B 6.1a"
          required
          context %(
            <p>Please outline what mechanisms are in place to communicate the benefits of the initiative.</p>
          )
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :initiative_member_engagement, "Explain if and how you engage the organisation’s members or employees in the design and implementation of your initiative." do
          classes "sub-question"
          sub_ref "B 6.2a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :initiative_long_term_plans, "What are your long-term plans for ensuring your organisation continues to promote opportunities through social mobility beyond what you already do." do
          classes "sub-question"
          sub_ref "B 6.3a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :initiative_organisation_benefits, "Are there any other benefits of the initiative to your organisation that you haven't yet outlined in the previous responses?" do
          classes "sub-question"
          sub_ref "B 6.4a"
          required
          context %(
            <p>This may include:</p>

            <p>Employee relations - improvements in employee motivation, well-being or satisfaction.</p>

            <p>Diversity - increased the ability to access and attract a wider talent pool.</p>

            <p>Reputation - increased positive perceptions of the organisation among key stakeholders - for example, customers and the media.</p>

            <p>Collaboration - best practices and learnings fed-back into other departments; increased cross-departmental collaboration.</p>
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :initiative_community_society_impact, "Impact on community and society." do
          sub_ref "B 7a"
          required
          question_sub_title %{
            What is the impact of your initiative on the local community and at a regional and national level; and how is this exemplary?
          }
          context %(
            <p>For example, has your initiative led to there being more people from disadvantaged backgrounds being in employment in your area that is higher than the national average? Has it increased recognition and awareness of these initiatives as being a valid route to employment? Has it led to higher employment outcomes regionally?</p>
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :initiative_investments, "Investments in the initiative" do
          sub_ref "B 8a"
          required
          question_sub_title %{
            List all investments and reinvestments (capital and operating costs) in your promoting opportunity through social mobility initiative. Include the year(s) in which they were made.
          }
          words_max 400
          conditional :application_category, "initiative"
        end

        # ORGANISATION QUESTIONS START HERE

        comment :organisation_question_guidance, "" do
          pdf_context_with_header_blocks [
            [:italic, "Answer the questions below if you selected option (b) in question B1 - your application is for the whole organisation whose core aim is to promote opportunity through social mobility."],
          ]
        end

        checkbox_seria :organisation_activities, "What activities did you implement to make a positive impact by promoting opportunity through social mobility?" do
          ref "B 2b"
          required
          classes "question-limited-selections"
          selection_limit 3
          context %(
            <p>If necessary, you can select more than one activity, but no more than three. If you feel that more than three activities are applicable, select the three that the initiative focuses on most.</p>
          )
          check_options [
            ["careers_advice", "<strong>Careers advice</strong> - providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes."],
            ["fairer_recruitment", "<strong>Fairer recruitment</strong> - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - socio-economic or academic."],
            ["skills_development", "<strong>Skills development</strong> - providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may include the development of aspirations and increasing motivation."],
            ["work_placements", "<strong>Work placements</strong> - preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships."],
            ["early_careers", "<strong>Early careers</strong> - fostering a youth-friendly culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers."],
            ["job_opportunities", "<strong>Job opportunities</strong> - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes."],
            ["advancement", "<strong>Advancement</strong> - developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes."],
            ["advocacy_and_leadership", "<strong>Advocacy and leadership</strong> - demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility."],
          ]
          conditional :application_category, "organisation"
        end

        header :organisation_header_b3b, "Details of how your organisation has made a significant difference by promoting opportunity through social mobility." do
          ref "B 3b"
          conditional :application_category, "organisation"
        end

        textarea :organisation_desc_short, "Provide a one-line description of your organisation in terms of how it promotes opportunity through social mobility." do
          classes "sub-question"
          sub_ref "B 3.1b"
          required
          context %(
            <p>This description will be used in publicity material if your application is successful.</p>
          )
          words_max 15
          conditional :application_category, "organisation"
        end

        textarea :organisation_desc_medium, "Briefly describe your core organisation, its aims, what it does and how it promotes opportunity through social mobility for people from disadvantaged backgrounds." do
          classes "sub-question"
          sub_ref "B 3.2b"
          required
          words_max 300
          conditional :application_category, "organisation"
        end

        textarea :organisation_motivations, "Outline the social mobility factors or issues that motivated your organisation to be founded or that led your organisation to focus on promoting opportunity through social mobility." do
          classes "sub-question"
          sub_ref "B 3.3b"
          required
          context %(
            <p>Please include details on:</p>

            <p>1. When was the organisation founded or when did it start focusing on promoting opportunity through social mobility?</p>

            <p>2. What was the situation before your organisation was founded or before it started focusing on promoting opportunity through social mobility? Please include details on what the issues or needs of the potential participants were.</p>

            <p>3. Why did you choose this particular focus area?</p>
          )
          words_max 500
          conditional :application_category, "organisation"
        end

        textarea :organisation_exemplary_evidence, "Please provide evidence of what makes your organisation exemplary." do
          classes "sub-question"
          sub_ref "B 3.4b"
          required
          context %(
            <p>Taking into account your mission, values and strategic objectives, provide details about how you have gone above and beyond in the context of your core aim, to promote opportunity through social mobility to disadvantaged groups.</p>

            <p>For example, you may feel your approach to bringing key people together and how you have created, improved and influenced your organisation sets you apart from your peers. If you have led the way by doing something that has never been done before, please provide evidence on what you did and how you did this.</p>

            <p>Your organisation may be exemplary as a result of an overall strategy to inform, guide, recruit and develop people or you may have formed effective partnerships and collaborations with organisations, bringing them together to support diversity and inclusion. It is important to provide evidence on how you did this.</p>
          )
          words_max 500
          conditional :application_category, "organisation"
        end

        header :organisation_header_b4b, "Measuring success" do
          ref "B 4b"
          context %(
            <p>The questions in B4 are not about the actual output or outcomes, but rather the targets you set and how you go about measuring outputs and outcomes against them.</p>
          )
          conditional :application_category, "organisation"
        end

        textarea :organisation_measuring_targets, "Describe what key performance indicators (KPIs) or equivalent targets you set and how you monitor them in the context of your core aim to promote opportunity through social mobility." do
          classes "sub-question"
          sub_ref "B 4.1b"
          required
          context %(
            <ul>
              <li>Provide information on what targets you set.</li>
              <li>Explain how you monitor performance against the target.</li>
              <li>Explain what evidence you gather to show short and longer-term outcomes - this may include but is not limited to - internal records, third party evidence, survey responses, interviews, ad-hoc feedback.</li>
            </ul>
          )
          pdf_context %(
              \u2022 Provide information on what targets you set.

              \u2022 Explain how you monitor performance against the target.

              \u2022 Explain what evidence you gather to show short and longer-term outcomes - this may include but is not limited to - internal records, third party evidence, survey responses, interviews, ad-hoc feedback.
          )

          words_max 500
          conditional :application_category, "organisation"
        end

        textarea :organisation_targets_not_met, "Explain what happens if you don’t meet the KPIs or alternative performance targets?" do
          classes "sub-question"
          sub_ref "B 4.2b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        header :organisation_header_b5b, "The impact on participants." do
          ref "B 5b"
          conditional :application_category, "organisation"
        end

        textarea :organisation_disadvantaged_groups, "Describe which disadvantaged groups you target." do
          classes "sub-question"
          sub_ref "B 5.1b"
          required
          context %(
            <p>This award aims to recognise promoting opportunity through social mobility efforts that focus on the disadvantaged groups listed below:</p>
            <ul>
              <li>People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;</li>
              <li>Asylum seekers and refugees or children of refugees;</li>
              <li>Young people (over 16 years old) with English as a second language;</li>
              <li>Long-term unemployed or people who grew up in workless households;</li>
              <li>People on low incomes;</li>
              <li>Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;</li>
              <li>People who received free school meals or if there are children in the person’s current household who receive free school meals;</li>
              <li>Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;</li>
              <li>Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;</li>
              <li>Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;</li>
              <li>People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;</li>
              <li>People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;</li>
              <li>People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;</li>
              <li>People recovering or who have recovered from addiction;</li>
              <li>Survivors of domestic violence;</li>
              <li>Military veterans;</li>
              <li>Ex-offenders;</li>
              <li>Families of prisoners.</li>
            </ul>
            <p>Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement.</p>
            <p> Please provide the totals and year by year breakdown of:</p>
            <ol>
              <li>the total number of participants;</li>
              <li>the proportion of participants from disadvantaged backgrounds;</li>
              <li>the breakdown of these participants by disadvantaged group;</li>
              <li>for each disadvantaged group, specify the participant age range and in what UK counties they are based.</li>
            </ol>
            <p>Please provide aggregate numbers for all the years as well as year by year breakdown for at least the last two years. The breakdown will help us understand the output and outcome data in question B5.2.</p>
          )
          pdf_context %(
            This award aims to recognise promoting opportunity through social mobility efforts that focus on the disadvantaged groups listed below:

              \u2022 People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;

              \u2022 Asylum seekers and refugees or children of refugees;

              \u2022 Young people (over 16 years old) with English as a second language;

              \u2022 Long-term unemployed or people who grew up in workless households;

              \u2022 People on low incomes;

              \u2022 Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;

              \u2022 People who received free school meals or if there are children in the person’s current household who receive free school meals;

              \u2022 Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;

              \u2022 Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;

              \u2022 Young people (over 16 years old) who are not in education, employment or training (NEET) or are at risk of that;

              \u2022 People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;

              \u2022 People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;

              \u2022 People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;

              \u2022 People recovering or who have recovered from addiction;

              \u2022 Survivors of domestic violence;

              \u2022 Military veterans;

              \u2022 Ex-offenders;

              \u2022 Families of prisoners.

              Please note to be eligible for the award, your target group members, the participants, have to be based in the UK and be over 16 years old at the start of the engagement. 

              Please provide the totals and year by year breakdown of:

              1. the total number of participants;

              2. the proportion of participants from disadvantaged backgrounds;

              3. the breakdown of these participants by disadvantaged group;

              4.for each disadvantaged group, specify the participant age range and in what UK counties they are based.

              Please provide aggregate numbers for all the years as well as year by year breakdown for at least the last two years. The breakdown will help us understand the output and outcome data in question B5.2.
          )
          words_max 300
          conditional :application_category, "organisation"
        end

        textarea :organisation_quantitative_evidence, "Provide quantitative evidence on the impact that your organisation has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.2b"
          required
          context %(
            <p>Provide <strong>quantitative data</strong> (for example, numbers, figures) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants.</p>
            <ul>
              <li>Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.</li>
              <li>Provide total figures of your overall impact over the years (minimum for the last two years).</li>
              <li>Provide year by year breakdown to demonstrate growth and improvement (minimum for the last two years).</li>
              <li>Include any <strong>output</strong> data. For example, a number of participants successfully completing a training course.</li>
              <li>Include any <strong>outcome</strong> data, including <strong>short-term</strong> and, where available, <strong>longer-term</strong> outcomes. For example, a number of participants who, after completing the course, gained employment and then how many of those are in employment after two years.</li>
              <li>Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.</li>
              <li>Explain where the data comes from - this may include, but is not limited to - internal records, third party evidence, survey responses.</li>
            </ul>
          )
          pdf_context %(
            Provide quantitative data (for example, numbers, figures) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants.

            \u2022 Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.

            \u2022 Provide total figures of your overall impact over the years (minimum for the last two years).

            \u2022 Provide year by year breakdown to demonstrate growth and improvement (minimum for the last two years).

            \u2022 Include any output data. For example, a number of participants successfully completing a training course.

            \u2022 Include any outcome data, including short-term and, where available, longer-term outcomes. For example, a number of participants who, after completing the course, gained employment and then how many of those are in employment after two years.

            \u2022 Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.

            \u2022 Explain where the data comes from - this may include, but is not limited to - internal records, third party evidence, survey responses.
          )
          words_max 750
          conditional :application_category, "organisation"
        end

        textarea :organisation_qualitative_evidence, "Provide qualitative evidence on the impact that your organisation has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.3b"
          required
          context %(
            <p>Provide <strong>qualitative data</strong> (for example, people stories as well as comments, feedback from participants and key stakeholders) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.</p>
            <ul>
              <li>Include stories of impact on participants’ lives. If possible, provide a range of examples.</li>
              <li>Include feedback that you have gathered from participants to understand how they have benefited.</li>
              <li>If applicable, include feedback that you have gathered from third-party stakeholders to understand how the participants have benefited. </li>
              <li>Explain where the information comes from - this may include, but is not limited to - surveys, interviews or ad-hoc feedback. </li>
            </ul>
          )
          pdf_context %(
            <p>Provide qualitative data (for example, people stories as well as comments, feedback from participants and key stakeholders) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.</p>

            \u2022 Include stories of impact on participants’ lives. If possible, provide a range of examples.

            \u2022 Include feedback that you have gathered from participants to understand how they have benefited.

            \u2022 If applicable, include feedback that you have gathered from third-party stakeholders to understand how the participants have benefited.

            \u2022 Explain where the information comes from - this may include, but is not limited to - surveys, interviews or ad-hoc feedback.
          )
          words_max 750
          conditional :application_category, "organisation"
        end

        textarea :organisation_feedback, "Describe what feedback, if any, you sought on how your organisation could be improved (in the context of your core aim to promote opportunity through social mobility). What, if any, of the suggested improvements have you implemented?" do
          classes "sub-question"
          sub_ref "B 5.4b"
          required
          context %(
            <ul>
              <li>Explain how you sought feedback.</li>
              <li>Include a summary of the feedback gathered such as participant or stakeholder quotes as well as quantitative data, for example, scores on how likely they are to recommend the organisation to their peers or similar ratings.</li>
              <li>Explain what, if any, of the suggested improvements have you implemented.</li>
            </ul>
          )
          pdf_context %(
            \u2022 Explain how you sought feedback.

            \u2022 Include a summary of the feedback gathered such as participant or stakeholder quotes as well as quantitative data, for example, scores on how likely they are to recommend the organisation to their peers or similar ratings.

            \u2022 Explain what, if any, of the suggested improvements have you implemented.
          )
          words_max 250
          conditional :application_category, "organisation"
        end

        header :organisation_header_b6b, "Impact on your organisation internally." do
          ref "B 6b"
          conditional :application_category, "organisation"
        end

        textarea :organisation_impact_sharing, "Explain if and how you share and celebrate the evidence of the impact across the organisation?" do
          classes "sub-question"
          sub_ref "B 6.1b"
          required
          context %(
            <p>Please outline what mechanisms are in place to communicate the benefits of your work.</p>
          )
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :organisation_member_engagement, "Explain if and how you engage the organisation’s members or employees in the design, implementation and evaluation of your work (in the context of your core aim to promote opportunity through social mobility)." do
          classes "sub-question"
          sub_ref "B 6.2b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :organisation_long_term_plans, "What are your long-term plans for ensuring your organisation continues to promote or improve the promotion of opportunities through social mobility beyond what you already do?" do
          classes "sub-question"
          sub_ref "B 6.3b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :organisation_community_society_impact, "Impact on community and society." do
          sub_ref "B 7b"
          required
          question_sub_title %{
            What is the impact of your organisation on the local community and at a regional and national level; and how is this exemplary?
          }
          context %(
            <p>For example, has your organisation’s activities led to there being more people from disadvantaged backgrounds being in employment in your area that is higher than the national average? Has it increased recognition and awareness of these initiatives as being a valid route to employment? Has it led to higher employment outcomes regionally?</p>
          )
          words_max 300
          conditional :application_category, "organisation"
        end
      end
    end
  end
end
