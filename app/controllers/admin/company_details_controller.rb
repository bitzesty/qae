class Admin::CompanyDetailsController < Admin::BaseController
  helper_method :resource
  include CompanyDetailsMixin
end
