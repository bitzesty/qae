namespace :db do
  desc "Populate of new buckingham palace's deadlines (media information,  confirm press book notes,  attendees invite) on current Settings"
  task populate_missing_buckingham_palace_deadlines: :environment do
    [
      'buckingham_palace_media_information',
      'buckingham_palace_confirm_press_book_notes',
      'buckingham_palace_attendees_invite'
    ].each do |kind|
      existing_deadline = Settings.current.deadlines.find_by(kind: kind)

      unless existing_deadline.present?
        Settings.current.deadlines.create!(kind: kind)
      end
    end
  end
end
