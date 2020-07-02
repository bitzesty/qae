class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :promoting_social_mobility,
            boolean: true,
            label: "Have you been promoting opportunity through social mobility?",
            accept: :true,
            hint: %(
              <a href='#' class='js-form-expandable-content-link' data-ref='js-promoting-social-mobility'>Read how we define Social Mobility</a>
              <div class='js-promoting-social-mobility hidden'>
                <p class='question-context'>Social mobility is a measure of the ability to move from a lower socio-economic background to higher socio-economic status.</p>
                <ul class='question-context'>
                  <li>Socio-economic background is a set of social and economic circumstances from which a person has come.</li>
                  <li>Socio-economic status is a person's current social and economic circumstances.</li>
                </ul>
                <p class='question-context'>For the purpose of this award, we classify people as being from a lower socio-economic background if they come from one of the below listed disadvantaged backgrounds:</p>
                <ul class='question-context'>
                  <li>People from Black, Asian and minority ethnic (BAME) backgrounds, including Gypsy and Traveller people;</li>
                  <li>Asylum seekers and refugees or children of refugees;</li>
                  <li>Long-term unemployed or people who grew up in workless households;</li>
                  <li>People whose children receive free school meals; </li>
                  <li>Lone parents - people bringing up a child or children without a partner; </li>
                  <li>People with a physical or mental disability that has a substantial and adverse long-term effect on a person’s ability to do normal daily activities;</li>
                  <li>Survivors of domestic violence;</li>
                  <li>Homeless and insecurely housed, including those at risk of becoming homeless and those in overcrowded or substandard housing;</li>
                  <li>Care leavers;</li>
                  <li>People recovering or who have recovered from addiction;</li>
                  <li>Ex-offenders;</li>
                  <li>Families of prisoners;</li>
                  <li>Military veterans;</li>
                  <li>People who receive or used to receive free school meals;</li>
                  <li>People whose parents’ or guardians’ highest level of qualifications by the time the person was 18 was secondary school.</li>
                </ul>
              </div>
            )

  property :social_mobility_activities,
            boolean: true,
            label: %(
              Have your promoting opportunity through social mobility efforts been through one of the following activities?<br/><br/>
              Careers Advice<br/>
              Fairer recruitment<br/>
              Skills development<br/>
              Work placements<br/>
              Early careers <br/>
              Job opportunities<br/>
              Advancement<br/>
              Advocacy and leadership<br/>
            ),
            accept: :true,
            hint: %(
              <a href='#' class='js-form-expandable-content-link' data-ref='js-social-mobility-activities'>Read more detailed descriptions of the activities</a>
              <div class='js-social-mobility-activities hidden'>
                <strong>Careers advice</strong> – providing careers advice or information to help people from disadvantaged backgrounds make more informed career choices as part of your recruitment initiatives such as traineeships, internships, apprenticeships or graduate schemes.<br/><br/>
                <strong>Fairer recruitment</strong> – widening your recruitment pool and making your recruitment process fairer by assessing potential skills rather than background - socio-economic or academic.<br/><br/>
                <strong>Skills development</strong> – providing activities or training to help people from disadvantaged backgrounds to develop hard skills (for example, numeracy, computer literacy, cooking) or soft skills (for example, workplace communication, effective workplace relationship development). This may include the development of aspirations and increasing motivation.<br/><br/>
                <strong>Work placements</strong> – preparing people from disadvantaged backgrounds for the world of work through inspiring work experiences and internships.<br/><br/>
                <strong>Early careers</strong> – fostering a youth-friendly culture in your workplace where younger employees from disadvantaged backgrounds are invested in and developed to progress in their careers.<br/><br/>
                <strong>Job opportunities</strong> – broadening access to job opportunities by creating accessible routes to employment. This could be by providing jobs for people from disadvantaged backgrounds leaving school, college, university or prisons, for example, through quality traineeships, internships, apprenticeships or graduate schemes.<br/><br/>
                <strong>Advancement</strong> – developing career paths to senior positions for those from disadvantaged backgrounds and track the progress of employees from non-graduate routes.<br/><br/>
                <strong>Advocacy and leadership</strong> – demonstrating strong external leadership or advocacy promoting social mobility within and beyond your organisation. For example, by getting more staff involved in efforts to improve social mobility, by encouraging supply chains to take action on social mobility.<br/><br/>
              </div>
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
              <a href='#' class='js-form-expandable-content-link' data-ref='js-evidence-of-impact'>Read what evidence we are looking for.</a>
              <div class='js-evidence-of-impact hidden'>
                <p>Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.</p>
                <p>The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.</p>
              </div>
            )

  property :application_category,
            label: "Is your application going to be for:",
            values: [
              ["initiative", "<strong>An initiative</strong> which promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds."],
              ["organisation", "<strong>A whole organisation</strong> whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."]
            ],
            context_for_options: {
              "initiative": "<a href='#' class='js-form-expandable-content-link' data-ref='js-application-category-initiative'>Read more about this option.</a>
                            <div class='js-application-category-initiative'>
                              <p>Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.</p>
                              <p>For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.</p>
                              <p>If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim.</p>
                            </div>",
              "organisation": "<a href='#' class='js-form-expandable-content-link' data-ref='js-application-category-organisation'>Read more about this option.</a>
                               <div class='js-application-category-organisation'>
                                 <p>For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects.</p>
                               </div>"
            },
            accept: :not_nil

  property :number_of_eligible_initiatives,
            positive_integer: true,
            label: "How many initiatives do you have that meets the criteria for the award?",
            accept: :not_nil,
            if: proc { application_category.present? && application_category == "initiative" }
end
