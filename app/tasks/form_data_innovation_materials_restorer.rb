# Example of use:
#
# FormInnovationMaterialsRestorer.restore_blanks
#
# FormInnovationMaterialsRestorer.restore_with_existing_data
#

class FormInnovationMaterialsRestorer
  class << self
    def forms_with_blank_data
      FormAnswer.submitted
                .where("date(updated_at) >= ?", Date.new(2015,10,1))
                .select do |f|
                  f.document["innovation_materials"].blank?
                end.select do |f|
        f.versions.present? &&
        f.versions.select do |v|
          v.object.present? &&
          v.object["document"]["innovation_materials"].present?
        end.count > 0
      end
    end

    def restore_blanks
      if forms_with_blank_data.present?
        puts ""
        puts "   FORMS with blank innovation_materials detected! (#{forms_with_blank_data.count})"
        puts "   IDs: #{forms_with_blank_data.map(&:id)}"
        puts ""

        forms_with_blank_data.each do |form|
          run(form)
        end
      else
        puts ""
        puts "   FORMS with blank innovation_materials are not exist"
        puts ""
      end

      nil
    end

    def forms_with_bad_data
      FormAnswer.submitted
                .where("date(updated_at) >= ?", Date.new(2015,10,1))
                .select do |f|
                  f.document["innovation_materials"].present? &&
                  f.document["innovation_materials"].all? { |k, v| v["description"].blank? }
                end.select do |f|
        f.versions.present? &&
        f.versions.select do |v|
          v.object.present? &&
          v.object["document"]["innovation_materials"].present?
        end.count > 0
      end
    end

    def restore_with_existing_data
      if forms_with_bad_data.present?
        puts ""
        puts "   FORMS with bad innovation_materials detected! (#{forms_with_bad_data.count})"
        puts "   IDs: #{forms_with_bad_data.map(&:id)}"
        puts ""

        forms_with_bad_data.each do |form|
          run(form)
        end
      else
        puts ""
        puts "   FORMS with bad innovation_materials are not exist"
        puts ""
      end

      nil
    end

    def run(form)
      day_after_deadline = Date.new(2015, 10, 1)

      all_versions = form.versions.select do |v|
        v.object.present? &&
        v.object["document"]["innovation_materials"].present?
      end.sort do |a, b|
        b.created_at <=> a.created_at
      end

      current = form.document['innovation_materials']

      puts "------------------------------"
      puts "   FORM ID: #{form.id} "
      puts ""
      puts "   current: #{current}"
      puts ""
      puts "   VERSION LIST: "

      all_versions.each_with_index do |v, index|
        puts ""
        puts "   VERSION #{index + 1}, date: #{v.created_at}: #{v.object["document"]["innovation_materials"]}"
        puts ""
      end

      print "Would you like to set one of versions? [y/n]: "
      resy = gets.chomp

      if resy.to_s == "y"
        puts "   VERSION SELECTION STARTED!"
      elsif resy.to_s == "n"
        puts "   Go Next Form!"
        return false
      end

      selected_version = nil

      all_versions.each_with_index do |v, index|
        next if selected_version.present?

        puts ""
        puts "   VERSION #{index + 1}, date: #{v.created_at}: #{v.object["document"]["innovation_materials"]}"
        puts ""

        print "Select this version? [y/n]: "
        response = gets.chomp

        current_version = v.object["document"]["innovation_materials"]

        case response
          when 'y'
            puts ""
            puts "   SELECTED VERSION: #{current_version}"
            puts ""

            print "Are you sure? [y/n]: "
            r = gets.chomp
            case r
              when 'y'
                selected_version = current_version

                puts "   VERSION SELECTED!"
              when 'n'
                puts "   Go Next version!"
            end

          when 'n'
            puts ""
            puts "   Skipping"
            puts ""
        end
      end

      puts ""
      puts "   selected_version: #{selected_version}"
      puts ""

      valid_attachments = false

      file_items = selected_version.select do |k, v|
        v["file"].present?
      end

      if file_items.present?
        puts "   files are present (file_items.count): #{file_items}!"
        puts ""

        valid_attachments = file_items.all? do |k, v|
          file = v["file"]
          fa = FormAnswerAttachment.find_by_id(file)
          fa.present?
        end
      else
        puts "   no files!"
        puts ""

        valid_attachments = true
      end

      if valid_attachments
        puts "   SUCCESS: VALID!"
        puts ""

        print "Restore it? [y/n]: "
        response = gets.chomp
        case response
          when 'y'
            puts ""
            puts "   RESTORE"
            puts ""

            # form.document["innovation_materials"] = selected_version
            # form.save!

            puts "   SAVED!"

          when 'n'
            puts ""
            puts "   Skipping"
            puts ""
        end

      else

        puts ""
        puts "   ERROR: Attachments are invalid"

        ids = selected_version.map { |k, v| v["file"] }

        puts "   Missing FormAnswerAttachment IDS: #{ids}"
        puts ""

      end

      puts ""
    end
  end
end
