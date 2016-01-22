class CspReportUriController < ApplicationController
  # This controller handles report_uri for
  # browser Content Security Policy errors
  # http://content-security-policy.com/
  # Content Security Policy settings are set config/initializers/secure_headers.rb

  def report
    render status: :ok
  end
end
