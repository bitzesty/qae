# See https://github.com/twitter/secureheaders#options-for-ensure_security_headers
::SecureHeaders::Configuration.configure do |config|
  config.hsts = { max_age: 20.years.to_i, include_subdomains: true }
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = { value: 1, mode: "block" }
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.csp = {
    default_src: "https: inline eval",
    img_src: "https:",

    # font_src - defines valid sources of fonts. (http://content-security-policy.com/)
    # This is fix for "[Report Only] Refused to load the font ..."
    # error message on Chrome/FF console
    # By default, we do not specify a font-src which means the value
    # should have taken the value of default-src ('none' in this case)
    # Below we add "font-src data:;" to whitelist the font being loaded.
    font_src: "'self' data:"
  }
end
