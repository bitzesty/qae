# frozen_string_literal: true

namespace :autosave_token do
  desc "Generage 'autosave_token' for existing admins and assessor"
  task generate_for_admins_and_assessors: :environment do
    puts "Generating autosave token..."

    admins = Admin.where(autosave_token: nil)
    admins.find_each do |admin|
      admin.send(:set_autosave_token)
      admin.save(validate: false)
      puts "created for admin #{admin.id}"
    end

    assessors = Assessor.where(autosave_token: nil)
    assessors.find_each do |assessor|
      assessor.send(:set_autosave_token)
      assessor.save(validate: false)
      puts "created for assessor #{assessor.id}"
    end

    puts "Completed!"
  end
end
