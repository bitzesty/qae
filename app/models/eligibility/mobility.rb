class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :can_provide_financial_figures,
            boolean: true,
            label: "Are you able to provide financial figures for the last three years for your organisation?",
            accept: :true,
            hint: "You will have to submit data for the last three financial years. Your latest financial year has to be the one that falls before the #{Settings.current_submission_deadline.decorate.formatted_trigger_time} (the submission deadline). If you haven't reached or finalised your latest year-end yet, you will be able to provide estimated figures."

  property :promoting_social_mobility,
            boolean: true,
            label: "Have you been promoting opportunity through social mobility?",
            accept: :true,
            hint: %(
              <details>
                <summary>
                  <span class="summary">
                    Read how we define Social Mobility</p<
                  </span>
                </summary>
                <div class="panel panel-border-narrow question-context">
                  <p>Social mobility is a measure of the ability to move from a lower socio-economic background to higher socio-economic status.</p>
                  <ul>
                    <li>Socio-economic background is a set of social and economic circumstances from which a person has come.</li>
                    <li>Socio-economic status is a person's current social and economic circumstances.</li>
                  </ul>
                  <p>For the purpose of this award, we classify people as being from a lower socio-economic background if they come from one of the below listed disadvantaged backgrounds:</p>
                  <ul>
                    <li>People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;</li>
                    <li>Asylum seekers and refugees or children of refugees;</li>
                    <li>Young people with English as a second language;</li>
                    <li>Long-term unemployed or people who grew up in workless households;</li>
                    <li>People on low incomes;</li>
                    <li>Lone parents - single adult heads of a household who are responsible for at least one dependent child, who normally lives with them;</li>
                    <li>People who received free school meals or if there are children in the person’s current household who receive free school meals;</li>
                    <li>Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;</li>
                    <li>Care leavers - people who spent time in care before the age of 18. Such care could be in foster care, children's homes, or other arrangements outside the immediate or extended family;</li>
                    <li>Young people who are not in education, employment or training (NEET) or are at risk of that;</li>
                    <li>People who attended schools with lower than average attainment or if there are children in the person’s current household who attend school with lower than average attainment;</li>
                    <li>People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school;</li>
                    <li>People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;</li>
                    <li>People recovering or who have recovered from addiction;</li>
                    <li>Survivors of domestic violence;</li>
                    <li>Military veterans;</li>
                    <li>Ex-offenders;</li>
                    <li>Families of prisoners.</li>
                  </ul>
                </div>
              </details>
            )

  property :social_mobility_activities,
            boolean: true,
            label: %(
              Have your promoting opportunity through social mobility efforts been through one of the following activities?
              <ul>
                <li>Careers Advice</li>
                <li>Fairer recruitment</li>
                <li>Skills development</li>
                <li>Work placements</li>
                <li>Early careers </li>
                <li>Job opportunities</li>
                <li>Advancement</li>
                <li>Advocacy and leadership</li>
              </ul>
            ),
            accept: :true,
            hint: %(
              <details>
                <summary>
                  <span class="summary">
                    Read more detailed descriptions of the activities
                  </span>
                </summary>
                <div class='panel panel-border-narrow question-context'>
                  <strong>Careers advice</strong> – providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.<br/><br/>
                  <strong>Fairer recruitment</strong> – widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - socio-economic or academic.<br/><br/>
                  <strong>Skills development</strong> – providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may include the development of aspirations and increasing motivation.<br/><br/>
                  <strong>Work placements</strong> – preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships.<br/><br/>
                  <strong>Early careers</strong> – fostering a youth-friendly culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers.<br/><br/>
                  <strong>Job opportunities</strong> – broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.<br/><br/>
                  <strong>Advancement</strong> – developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes.<br/><br/>
                  <strong>Advocacy and leadership</strong> – demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.<br/><br/>
                </div>
              </details>
            )

  property :active_for_atleast_two_years,
            boolean: true,
            label: "Have you had these activities for at least two years?",
            accept: :true

  property :evidence_of_impact,
            boolean: true,
            label: "Are you able to provide evidence of the impact of your promoting opportunity through social mobility activities?",
            accept: :true,
            hint: %(
              <details>
                <summary>
                  <span class="summary">
                    Read what evidence we are looking for
                  </span>
                </summary>

                <div class='panel panel-border-narrow question-context'>
                  <p>Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.</p>
                <p>The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.</p>
                </div>
              </details>
            )

  property :application_category,
            label: "Is your application going to be for:",
            values: [
              ["initiative", "<strong>An initiative</strong> which promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds."],
              ["organisation", "<strong>A whole organisation</strong> whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."]
            ],
            context_for_options: {
              "initiative": "<details>
                              <summary>
                                <span class='summary'>
                                  Read more about this option
                                </span>
                              </summary>

                              <div class='panel panel-border-narrow question-context'>
                                <p>Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.</p>
                                <p>For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.</p>
                                <p>If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim.</p>
                              </div>
                            </details>",

              "organisation": "<details>
                              <summary>
                                <span class='summary'>
                                  Read more about this option
                                </span>
                              </summary>

                              <div class='panel panel-border-narrow question-context'>
                                <p>For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects.</p>
                              </div>
                            </details>"
            },
            accept: :not_nil

  property :number_of_eligible_initiatives,
            positive_integer: true,
            label: "How many initiatives do you have that meets the criteria for the award?",
            accept: :not_nil,
            if: proc { application_category.present? && application_category == "initiative" }
end
