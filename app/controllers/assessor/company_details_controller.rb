class Assessor::CompanyDetailsController < Assessor::BaseController
  helper_method :resource
  include CompanyDetailsMixin
end
