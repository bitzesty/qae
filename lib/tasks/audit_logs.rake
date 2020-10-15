namespace :audit_logs do
  desc "Creates an AuditLog record for each PaperTrail::Version saved against a FormAnswer"
  task create_from_papertrail_versions: :environment do
    ActiveRecord::Base.transaction do
      nil_user = User.find_by(email: "nil_user@bitzesty.com") || User.create!(nil_user_params)

      PaperTrail::Version.find_in_batches do |versions|
        audit_log_attrs = versions.map do |version|
          attrs = {
            action_type: version.event,
            auditable_type: version.item_type,
            auditable_id: version.item_id,
            created_at: version.created_at
          }

          if version.whodunnit.present?
            attrs[:subject_type] = version.whodunnit.split(':').first.capitalize
            attrs[:subject_id] = version.whodunnit.split(':').second
          else
            attrs[:subject_type] = "User"
            attrs[:subject_id] = nil_user.id
          end

          attrs
        end

        AuditLog.create!(audit_log_attrs) # Creates records in batches
      end
    end
  end

  def nil_user_params
    {
      email: "nil_user@bitzesty.com",
      password: "3o5to6&WY#MLaj!IeuJS",
      agreed_with_privacy_policy: '1',
      role: "regular",
      first_name: "a",
      last_name: "user"
    }
  end
end
