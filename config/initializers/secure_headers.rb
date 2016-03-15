# See https://github.com/twitter/secureheaders#options-for-ensure_security_headers
# TODO Update to x3
::SecureHeaders::Configuration.configure do |config|
  config.hsts = { max_age: 20.years.to_i, include_subdomains: true }
  config.x_frame_options = "SAMEORIGIN"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = { value: 1, mode: "block" }
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.csp = {
    default_src: "https: inline eval 'self' data:",
    report_uri: "/csp_report_uri"
  }
end
