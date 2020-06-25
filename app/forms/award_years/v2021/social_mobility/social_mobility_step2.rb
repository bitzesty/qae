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
              This section enables you to present the details of how your organisation has made a difference by promoting opportunity through social mobility. This may have been as a core aim of your organisation or achieved via a social mobility initiative. Your answers will provide us with evidence on how this benefits the participants, your organisation and wider society.
            )],

            [:bold, "Definition of Social Mobility"],
            [:normal, %(
              Social mobility is a measure of the ability to move from a lower socio-economic background to a higher socio-economic status.

              \u2022 Socio-economic background is a set of social and economic circumstances from which a person has come.

              \u2022 Socio-economic status is a person's current social and economic circumstances.

              Socio-economic background is a set of social and economic circumstances from which a person has come. Socio-economic status is a person's current social and economic circumstances.

              We classify people as being from a lower or higher socio-economic background based on these variables:

              \u2022 The National Statistics Socio-economic classification (NS-SEC) of parent's occupation.

              \u2022 This is based on the type of job the main or highest income earner in the household had as their main job when the person was 14.

              \u2022 Whether they were receiving free school meals.

              \u2022 The highest level of qualifications achieved by either parent(s) or guardian(s) by the time the person was 18.

              \u2022 The type of school the person attended.
            )],

            [:bold, "Overarching criteria"],
            [:normal, %(
              We are looking to recognise:

              a\) Initiatives that promote opportunity through social mobility. These initiatives should be structured and designed to target and support people from disadvantaged backgrounds.

              Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.

              It does not have to be large if your organisation is small - we will evaluate it in proportion to the organisation’s size. However, it has to be structured.

              For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain percentage of recruits to come from disadvantaged backgrounds.

              If your organisation has more than one initiative that meets the criteria for the award, please submit separate applications for each initiative.

              If your application is for an initiative, promoting opportunity through social mobility does not have to be your organisation's core aim.

              b\) Organisations whose core day-to-day aim is to promote opportunity through social mobility; These organisations exist purely to support people from disadvantaged backgrounds.

              For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects.
            )],

            [:bold, "Evidence"],
            [:normal, %(
              Applicants need to provide quantifiable evidence to support the claims made. This should be from the numbers presented, third-party evaluations and feedback received from those who have received support.

              When providing quantitative evidence, provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.

              When considering qualitative evidence, where possible, provide a range of examples.

              In the case of feedback, it needs to be an analysis of any scores or ratings, including positive, negative and neutral feedback. Ad-hoc quotes and anecdotal feedback will strengthen your application but are not sufficient on their own.
            )],

            [:bold, "Small organisations"],
            [:normal, %(
              The Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is a reasonable performance, given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],

            [:bold, "Answering questions"],
            [:normal, %(
              Please try to avoid using technical jargon in this section. If you use acronyms, these should be explained clearly in the first instance.
            )]
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
          pdf_context %(
            <p>Select whether your application is for an initiative or organisation</p>

            <p>For initiatives, please answer questions B3a, B4a, B5a, B6a and B7a</p>
            <p>For organisations, please answer questions B3b, B4b, B5b, B6b and B7b</p>
          )
          option "initiative", "a) An initiative that promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds.  If your organisation has more than one initiative that meets the criteria for the award, please submit separate applications for each initiative."
          option "organisation", "b) A whole organisation whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."
          default_option "initiative"
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
            ["careers_advice", "Careers advice - providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes."],
            ["fairer_recruitment", "Fairer recruitment - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - social-economic or academic."],
            ["skills_development", "Skills development - providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may also include, development of aspirations and increasing motivation."],
            ["work_placements", "Work placements - preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships."],
            ["early_careers", "Early careers - fostering a ‘youth-friendly’ culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers."],
            ["job_opportunities", "Job opportunities - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes."],
            ["advancement", "Advancement - developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes."],
            ["advocacy_and_leadership", "Advocacy and leadership - demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility."]
          ]
          conditional :application_category, "initiative"
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
            ["careers_advice", "Careers advice - providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes."],
            ["fairer_recruitment", "Fairer recruitment - widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - social-economic or academic."],
            ["skills_development", "Skills development - providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may also include, development of aspirations and increasing motivation."],
            ["work_placements", "Work placements - preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships."],
            ["early_careers", "Early careers - fostering a ‘youth-friendly’ culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers."],
            ["job_opportunities", "Job opportunities - broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes."],
            ["advancement", "Advancement - developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes."],
            ["advocacy_and_leadership", "Advocacy and leadership - demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility."]
          ]
          conditional :application_category, "organisation"
        end

        header :initiative_header_b3a, "Summary of your promoting opportunity through social mobility." do
          ref "B 3a"
          conditional :application_category, "initiative"
        end

        header :organisation_header_b3b, "Details of how your organisation has made a significant difference by promoting opportunity through social mobility." do
          ref "B 3b"
          conditional :application_category, "organisation"
        end

        textarea :initiative_desc_short, "Provide a one-line description of your social initiative programme." do
          classes "sub-question"
          sub_ref "B 3.1a"
          required
          context %(
            <p>This description will be used in publicity material if your application is successful.</p>
          )
          words_max 15
          conditional :application_category, "initiative"
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

        textarea :initiative_desc_medium, "Briefly describe the initiative, its aims, what it provides and how it promotes opportunity through social mobility." do
          classes "sub-question"
          sub_ref "B 3.2a"
          required
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :organisation_desc_medium, "Briefly describe your core organisation, its aims, what it does and how it promotes opportunity through social mobility for people from disadvantaged backgrounds." do
          classes "sub-question"
          sub_ref "B 3.2b"
          required
          words_max 300
          conditional :application_category, "organisation"
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

        textarea :organisation_motivations, "Outline the social mobility factors or issues that motivated your organisation to be founded or that led your organisation to focus on promoting opportunity through social mobility. " do
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

        textarea :initiative_disadvantaged_groups, "Describe which disadvantaged groups the initiative targets." do
          classes "sub-question"
          sub_ref "B 3.4a"
          required
          context %(
            <p>For each of the last three years, please provide details on:</p>

            <p>1. the total number of participants in the initiative.</p>

            <p>2. the proportion of participants from disadvantaged backgrounds.</p>

            <p>3. the breakdown of these participants by disadvantage.</p>

            <p>Please note, if the initiative has been running for more than three years, you can mention the aggregate numbers for all the years, but provide the breakdown only for the last three years.</p>
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :initiative_exemplary_evidence, "Provide evidence of what makes the initiative exemplary." do
          classes "sub-question"
          sub_ref "B 3.5a"
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

        header :initiative_header_b4a, "Measuring success" do
          ref "B 4a"
          context %(
            <p>We want to know what quantitative and qualitative measures are used to set targets and evaluate the success of your initiative.</p>
          )
          conditional :application_category, "initiative"
        end

        header :organisation_header_b4b, "Measuring success" do
          ref "B 4b"
          context %(
            <p>The questions in B4 are not about the actual output or outcomes, but rather the targets you set and how you go about measuring outputs and outcomes against them.</p>
          )
          conditional :application_category, "organisation"
        end

        textarea :initiative_day_to_day_running, "Who is responsible for, and who runs the initiative day-to-day?" do
          classes "sub-question"
          sub_ref "B 4.1a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :initiative_measuring_targets, "Describe what key performance indicators (KPIs) or equivalent targets are being used and how they are set and monitored in the context of your initiative." do
          classes "sub-question"
          sub_ref "B 4.2a"
          required
          context %(
            <p>Focus on what targets you set for the initiative and how you monitor performance against them.</p>
          )
          words_max 500
          conditional :application_category, "initiative"
        end

        textarea :organisation_measuring_targets, "Describe what key performance indicators (KPIs) or equivalent targets are being used and how they are set and monitored in the context of your initiative." do
          classes "sub-question"
          sub_ref "B 4.1b"
          required
          context %(
            <ul>
              <li>Provide information on what targets you set.</li>
              <li>Explain how you monitor performance against the target.</li>
              <li>Explain what evidence you gather to show short and long term outcomes - this may include, but is not limited to - internal records, third party evidence, survey responses.</li>
            </ul>
          )
          pdf_context %(
              \u2022 Provide information on what targets you set.

              \u2022 Explain how you monitor performance against the target.

              \u2022 Explain what evidence you gather to show short and long term outcomes - this may include, but is not limited to - internal records, third party evidence, survey responses.
          )

          words_max 500
          conditional :application_category, "organisation"
        end

        textarea :initiative_targets_not_met, "Explain what happens if your KPIs or alternative performance targets are not met?" do
          classes "sub-question"
          sub_ref "B 4.3a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :organisation_targets_not_met, "Explain what happens if your KPIs or alternative performance targets are not met?" do
          classes "sub-question"
          sub_ref "B 4.2b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :initiative_scale, "How does the scale of your initiative compare with the wider work of your organisation?" do
          classes "sub-question"
          sub_ref "B 4.4a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        header :initiative_header_b5a, "The impact on participants." do
          ref "B 5a"
          context %(
            <p>Provide evidence about the impact of your initiative on participants.</p>

            <p>Please make reference to your KPIs or equivalent performance targets and use a balance of quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, comments, feedback from participants and key stakeholders).</p>
          )
          conditional :application_category, "initiative"
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
            <p>Please provide the totals and year by year breakdown of:</p>

            <p>1. the total number of participants.</p>

            <p>2. the proportion of participants from disadvantaged backgrounds.</p>

            <p>3. the breakdown of these participants by disadvantage.</p>

            <p>Please provide aggregate numbers for all the years as well as year by year breakdown for at least the last three years. The breakdown will help us understand the changes in your activities over time and will frame the output and outcome data in question B5.2.</p>
          )
          words_max 300
          conditional :application_category, "organisation"
        end

        textarea :initiative_impact, "Quantify what impact has your initiative achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.1a"
          required
          context %(
            <p>For the last three years, please break down the impact by year to show growth and improvement and include the longer-term outcomes. Please include any outcome and output data you have gathered to evaluate the initiative; and provide evidence of what retention data you gather to show long-term impact.</p>

            <p>Explain the impact in the context of the key barriers and drivers for change.</p>

            <p>Focus on data that shows how your initiative has brought about meaningful change or improved the employability and sustainability of the participants; and how it has raised their career aspirations and confidence.</p>
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :organisation_quantitative_evidence, "Provide quantitative evidence on the impact that your organisation has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.2b"
          required
          context %(
            <p>Provide <strong>quantitative data</strong> (for example, numbers, figures) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants.</p>
            <ul>
              <li>Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.</li>
              <li>Provide total figures of your overall impact over the years (minimum for the last three years).</li>
              <li>Provide year by year breakdown to demonstrate growth and improvement (minimum for the last three years).</li>
              <li>Include any output data. For example, a number of participants successfully completing a training course.</li>
              <li>Include any outcome data, including short-term and, where available, long-term outcomes. For example, a number of participants who, after completing the course, gained employment (short-term outcome) and then how many of those are in employment after 2 years (long-term outcome).</li>
              <li>Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.</li>
              <li>Reference any evidence - this may include, but is not limited to - internal records, third party evidence, survey responses.</li>
            </ul>
          )
          pdf_context %(
            <p>Provide quantitative data (for example, numbers, figures) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants.</p>

            \u2022 Explain your impact in the context of your KPIs or equivalent performance targets that you have identified in section B4.

            \u2022 Provide total figures of your overall impact over the years (minimum for the last three years).

            \u2022 Provide year by year breakdown to demonstrate growth and improvement (minimum for the last three years).

            \u2022 Include any output data. For example, a number of participants successfully completing a training course.

            \u2022 Include any outcome data, including short-term and, where available, long-term outcomes. For example, a number of participants who, after completing the course, gained employment (short-term outcome) and then how many of those are in employment after 2 years (long-term outcome).

            \u2022 Provide actual numbers, not just percentages - while percentages might be useful, they are not sufficient on their own.

            \u2022 Reference any evidence - this may include, but is not limited to - internal records, third party evidence, survey responses.
          )
          words_max 500
          conditional :application_category, "organisation"
        end

        textarea :organisation_qualitative_evidence, "Provide qualitative evidence on the impact that your organisation has achieved for your participants." do
          classes "sub-question"
          sub_ref "B 5.3b"
          required
          context %(
            <p>Provide <strong>qualitative data</strong> (for example, comments, feedback from participants and key stakeholders) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.</p>
            <ul>
              <li>Include qualitative feedback that you have gathered <strong>from participants</strong> to understand how they have benefited. For example, you can include data, such as quotes, from participant surveys, interviews or ad-hoc feedback.</li>
              <li>If applicable, include qualitative feedback that you have gathered from <strong>third-party stakeholders</strong> to understand how the participants have benefited.</li>
            </ul>
          )
          pdf_context %(
            <p>Provide qualitative data (for example, comments, feedback from participants and key stakeholders) that shows how your organisation has brought about meaningful change or improved the employability and sustainability of the participants and how it has raised their career aspirations and confidence.</p>

            \u2022 Include qualitative feedback that you have gathered from participants to understand how they have benefited. For example, you can include data, such as quotes, from participant surveys, interviews or ad-hoc feedback.

            \u2022 If applicable, include qualitative feedback that you have gathered from third-party stakeholders to understand how the participants have benefited.
          )
          words_max 500
          conditional :application_category, "organisation"
        end

        textarea :initiative_feedback, "Describe what feedback, if any, you have gathered from participants to understand whether they feel they have benefited from your initiative." do
          classes "sub-question"
          sub_ref "B 5.2a"
          required
          context %(
            <p>For example, you can include data from participant surveys, interviews or ad-hoc feedback. Include qualitative feedback such as participant quotes as well as quantitative data, for example, scores on how likely they are to recommend the initiative to their peers or similar ratings.</p>
          )
          words_max 300
          conditional :application_category, "initiative"
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

        textarea :initiative_improvements, "Describe what feedback, if any, you sought on how the initiative could be improved? What, if any, of the suggested improvements have you implemented?" do
          classes "sub-question"
          sub_ref "B 5.3a"
          required
          words_max 250
          conditional :application_category, "initiative"
        end

        header :initiative_header_b6a, "Impact on your organisation." do
          ref "B 6a"
          conditional :application_category, "initiative"
        end

        header :organisation_header_b6b, "Impact on your organisation internally." do
          ref "B 6b"
          conditional :application_category, "organisation"
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

        textarea :organisation_impact_sharing, "Explain if and how you share and celebrate the evidence of the initiative’s impact across the organisation?" do
          classes "sub-question"
          sub_ref "B 6.1b"
          required
          context %(
            <p>Please outline what mechanisms are in place to communicate the benefits of your work.</p>
          )
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :initiative_member_invitation, "Explain if and how you invite the organisation’s members or employees in the design and implementation of your initiative." do
          classes "sub-question"
          sub_ref "B 6.2a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :organisation_member_invitation, "Explain if and how you invite the organisation’s members or employees in the design, implementation and evaluation of your work (in the context of your core aim to promote opportunity through social mobility)." do
          classes "sub-question"
          sub_ref "B 6.2b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :initiative_long_term_plans, "What are your long-term plans for ensuring your organisation continues to promote opportunities through social mobility beyond what you already do." do
          classes "sub-question"
          sub_ref "B 6.3a"
          required
          words_max 200
          conditional :application_category, "initiative"
        end

        textarea :organisation_long_term_plans, "What are your long-term plans for ensuring your organisation continues to promote or improve the promotion of opportunities through social mobility beyond what you already do?" do
          classes "sub-question"
          sub_ref "B 6.3b"
          required
          words_max 200
          conditional :application_category, "organisation"
        end

        textarea :organisation_benefits, "Are there any other benefits of the initiative to your organisation that have not yet been outlined in your previous responses?" do
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
          classes "sub-question"
          sub_ref "B 7a"
          required
          context %(
            <p>What is the impact of your initiative on the local community and at a regional and national level?</p>
          )
          words_max 300
          conditional :application_category, "initiative"
        end

        textarea :organisation_community_society_impact, "Impact on community and society." do
          classes "sub-question"
          sub_ref "B 7b"
          required
          context %(
            <p>What is the impact of your organisation on the local community and at a regional and national level; and how is this exemplary?</p>
          )
          words_max 300
          conditional :application_category, "organisation"
        end
      end
    end
  end
end
