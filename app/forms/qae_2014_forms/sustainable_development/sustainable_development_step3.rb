class QAE2014Forms
  class << self
    def development_step3
      @development_step3 ||= Proc.new {
        context %Q{
          <p>When answering these questions please avoid using technical jargon where possible.</p>
        }

        options :my_entry_relates_to, "My entry relates to" do
          ref 'C 1'
          option "product service", "A product/service"
          option "management approach", "A management approach"
          option "both", "Both the above"
        end

        textarea :development_desc_short, 'Briefly describe your product/service/management approach' do
          ref 'C 2'
          context %Q{
            <p>eg. Arts Company:  “Sustainable print marketing for arts and tourism”; Energy Company:  “Management and delivery of commercial and domestic projects to tackle fuel poverty, energy efficiency and carbon reduction”.</p>
          }
          rows 2
          words_max 15
        end

        textarea :development_desc_long, 'Describe your product/service/management approach in detail' do
          ref 'C 3'
          context %Q{
            <p>Include a brief description of its origin and develpoment.</p>
          }
          rows 5
          words_max 500
        end

        textarea :development_approach, 'Describe your approach to managing resources and/or relationships' do
          ref 'C 4'
          context %Q{
            <p>Please provide details of any plans, policies, strategies, etc. that you have in place to guide resource and relationship management. Please identify the roles, teams, departments, etc. responsible for the management of resources and/or relationships and how they achieve successful, sustainable management of these.</p>
          }
          rows 5
          words_max 500
        end

        header :provide_evidence_header, '' do
          context %Q{
            <p>Where possible, provide evidence of your contributions to each of the dimensions of sustainable develpoment below. If your contribution is weak in any of them, describe the relevant actions taken to improve this.</p>
          }
        end

        textarea :environmental_contribution, 'Explain the ways in which your approach contributes to environmental dimensions of sustainable development.' do
          ref 'C 5'
          context %Q{
            <p>Environmental dimensions' means respecting the limits of the planet’s environment, resources and biodiversity e.g. resource efficiency,  waste reduction and biological diversity/productivity.</p>
          }
          rows 5
          words_max 750
        end

        textarea :social_contribution, 'Explain the ways in which your approach contributes to social dimensions of sustainable development.' do
          classes "sub-question"
          context %Q{
            <p>Social dimensions' means towards the needs of people in present and future communities, promoting wellbeing, cohesion and equal opportunities e.g. health and safety, lifelong learning, and building strong communities.</p>
          }
          rows 5
          words_max 750
        end

        textarea :economic_contribution, 'Explain the ways in which your approach contributes to economic dimensions of sustainable development.' do
          classes "sub-question"
          context %Q{
            <p>Economic dimensions' means building a fair, sustainable economy which provides prosperity and opportunity for all e.g. productivity, socially useful activity (eg. assisting the long term unemployed into work), supporting local economies.</p>
          }
          rows 5
          words_max 750
        end

        textarea :leadership_contribution, 'Explain the ways in which your approach contributes to leadership dimensions of sustainable development.' do
          classes "sub-question"
          context %Q{
            <p>Leadership dimensions' means actively promoting effective, participative systems of governance in all levels of society e.g. promotion of sustainable development, increasing access to information, management innovation, ethical conduct.</p>
          }
          rows 5
          words_max 750
        end

        textarea :sector_leader_desc, 'Describe the ways in which you demonstrate sector leading sustainability performance.' do
          ref 'C 6'
          context %Q{
            <p>This could include describing how you benchmark your performance against others in your sector.</p>
          }
          rows 5
          words_max 750
        end

        options :external_contribution, 'Did any external organisation or individiual contribute to this product/service/initiative?' do
          ref 'C 7'
          required
          context %Q{
            <p>Excluding any joint entrant(s) named in C5.</p>
          }
          yes_no
        end

        textarea :sector_leader, 'Describe the ways in which you demonstrate sector leading sustainability performance.' do
          classes "sub-question"
          required
          rows 5
          words_max 500
          conditional :external_contribution, :yes
        end

        options :entrants_aware, "Are they aware that you are applying for this award?" do
          classes "sub-question"
          required
          conditional :external_contribution, :yes

          option "yes", "Yes, they are aware"
          option "no", "No, they are not aware"
          option "some", "Some are aware"
        end

        options :another_org_licensed, 'Is the product/service/initiative under license from another organisation?' do
          ref 'C 8'
          yes_no
        end

        textarea :licensing_agreement, 'Briefly describe the licensing arrangement.' do
          classes "sub-question"
          required
          rows 5
          words_max 100
          conditional :another_org_licensed, :yes
        end

        options :grant_support, 'Have you received any grant funding to support this innovation?' do
          ref 'C 9'
          required
          yes_no
        end

        textarea :grant_details, 'Please give details of date(s), source(s) and level(s) of funding.' do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :grant_support, :yes
        end

        number :innovation_years_by_applicant, 'How long has it been since the product/service/initiative was released into the marketplace?' do
          ref 'C 10'
          required
          max 100
          unit ' years'
          style "small inline"
        end

        options :you_released_product, 'Was the product/service/intiative released by you?' do
          classes "sub-question"
          required
          yes_no
        end

        number :product_age, 'How many years have you had it in the marketplace?' do
          classes "regular-question inline-input-question"
          required
          max 100
          unit ' years'
          style "small inline"
          conditional :you_released_product, :no
        end

        textarea :development_additional_comments, 'Additional comments (optional)' do
          classes "sub-question"
          rows 5
          words_max 200
        end

        materials :development_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'C 10'
          context %Q{
            <p>We can't guarantee these will be reviewed, so inlcude any vital information within the form.</p>
            <p>You may upload files of less than 5mb each in either MS Word Document, PDF, MS Excel Spreadsheet or MS Powerpoint Presentation formats. Or MP4 (video) files of up to TODOmb</p>
          } # TODO!
          help 'Information we will not review', %Q{
            <p>We will not consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitue for completing sections of the form.</p>
          }
        end
      }
    end
  end
end
