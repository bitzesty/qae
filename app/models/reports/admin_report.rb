class Reports::AdminReport
  ADMIN_REPORT3 = 'admin_report3'

  def initialize(id)
    @id = id
  end

  def build
    if @id == ADMIN_REPORT3
      AdminReport3Builder.new.build
    end
  end

  class AdminReport3Decorator
    # todo - custom logic for data collecting
  end

  class AdminReport3Builder
    MAPPING = [
      {
        label: 'URN',
        method: :urn
      },
      {
        label: 'ApplicantName'
      },
      {
        label: 'RegisteredUserId',
        method: :user_id
      },
      {
        label: 'RegisteredUserTitle'
      },
      {
        label: 'RegisteredUserFirstname'
      },
      {
        label: 'RegisteredUserSurname'
      },
      {
        label: 'RegisteredUserEmail'
      },
      {
        label: 'RegisteredUserCompany'
      },
      {
        label: 'RegisteredUserAddressLine1'
      },
      {
        label: 'RegisteredUserAddressLine2'
      },
      {
        label: 'RegisteredUserAddressLine3'
      },
      {
        label: 'RegisteredUserPostcode'
      },
      {
        label: 'RegisteredUserTelephone1'
      },
      {
        label: 'RegisteredUserTelephone2'
      },
      {
        label: 'RegisteredUserMobile'
      },
      {
        label: 'FormType',
        method: :award_type
      },
      {
        label: 'PercentageComplete'
      },
      {
        label: 'Section 1'
      },
      {
        label: 'Section 2'
      },
      {
        label: 'Section 4'
      },
      {
        label: 'Section 5'
      },
      {
        label: 'Section 6'
      },
      {
        label: 'Created'
      },
      {
        label: 'UserCreationDate'
      },
      {
        label: 'BusinessSector'
      },
      {
        label: 'BusinessSectorOther'
      },
      {
        label: 'Region'
      },
      {
        label: 'Employees'
      },
      {
        label: 'QAOPermission'
      },
      {
        label: 'HowDidYouHearAboutQA'
      },
      {
        label: 'HowDidYouHearAboutQAOther'
      }

    ]

    def initialize
      @scope = FormAnswer.all
    end

    require 'csv'

    def build
      csv_string = CSV.generate do |csv|
        csv << MAPPING.map{|m| m[:label]}
        @scope.each do |rec|
          row = []
          MAPPING.each do |map|
            meth = map[:method]

            if meth.present?
              if rec.respond_to?(meth)
                row << rec.send(meth)
              else
                row << 'not implemented yet'
              end
            else
              row << 'not implemented'
            end
          end
          csv << row
        end
      end

      csv_string
    end
  end
end
