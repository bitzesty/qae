module OmniAuth
  module Strategies
    class DbtStaffSso < OmniAuth::Strategies::OAuth2
      URL = ENV.fetch("DBT_STAFF_SSO_URL", nil) # remove the nils once we have these set in ci etc
      INFO_PATH = ENV.fetch("DBT_STAFF_SSO_INFO_PATH", nil)
      INFO_FIELD_NAMES = [
        "first_name",
        "last_name",
        "email",
      ]

      option :name, :dbt_staff_sso
      option :client_options, site: URL
      option :pkce, true

      uid do
        raw_info["id"]
      end

      info do
        INFO_FIELD_NAMES.index_with do |field_name|
          raw_info[field_name]
        end
      end

      def raw_info
        @raw_info ||= access_token.get(INFO_PATH).parsed
      end
    end
  end
end
