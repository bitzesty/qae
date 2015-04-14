namespace :form_answers do

  desc 'Adds search indexed data'
  task refresh_search_indexes: :environment do
    FormAnswer.find_each do |f|
      user = f.user
      if user.present?
        f.user_full_name = user.full_name
        f.save
      end
    end
  end

  desc "Adds assessors fk"
  task refresh_assessors_ids: :environment do
    FormAnswer.find_each do |f|
      primary = f.assessors.primary
      secondary = f.assessors.secondary
      f.primary_assessor_id = primary.try(:id)
      f.secondary_assessor_id = secondary.try(:id)
      f.save
    end
  end

  # For single use only
  desc "Rebuilds the urns for all apps"
  task rebuild_urn: :environment do
    FormAnswer.connection.execute("ALTER SEQUENCE urn_seq RESTART")
    FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_promotion RESTART")
    FormAnswer.update_all(urn: nil)
    FormAnswer.find_each(&:save!)
  end
end
