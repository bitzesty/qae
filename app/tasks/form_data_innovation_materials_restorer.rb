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
      @corrected_ids = []

      if forms_with_blank_data.present?
        all_ids = forms_with_blank_data.map(&:id)

        puts ""
        puts "   FORMS with blank innovation_materials detected! (#{forms_with_blank_data.count})"
        puts "   IDs: #{all_ids}"
        puts ""

        forms_with_blank_data.each do |form|
          run(form)
        end

        puts ""
        puts "   FIXED #{@corrected_ids.count} entries"
        puts "   FIXED IDs: #{@corrected_ids}"
        puts ""

        not_fixed_ids = all_ids - @corrected_ids

        puts ""
        puts "   NOT FIXED #{not_fixed_ids.count} entries"
        puts "   NOT FIXED IDs: #{not_fixed_ids}"
        puts ""
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
      @corrected_ids = []

      if forms_with_bad_data.present?
        all_ids = forms_with_bad_data.map(&:id)

        puts ""
        puts "   FORMS with bad innovation_materials detected! (#{forms_with_bad_data.count})"
        puts "   IDs: #{all_ids}"
        puts ""

        forms_with_bad_data.each do |form|
          run(form)
        end

        puts ""
        puts "   FIXED #{@corrected_ids.count} entries"
        puts "   FIXED IDs: #{@corrected_ids}"
        puts ""

        not_fixed_ids = all_ids - @corrected_ids

        puts ""
        puts "   NOT FIXED #{not_fixed_ids.count} entries"
        puts "   NOT FIXED IDs: #{not_fixed_ids}"
        puts ""
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

      all_versions.each_with_index do |ver, index|

        mats = ver.object["document"]["innovation_materials"]

        puts ""
        puts "     VERSION #{index + 1}, date: #{ver.created_at}: #{mats}"
        puts ""

        v_file_items = mats.select do |key, value|
          value["file"].present?
        end

        if v_file_items.present?
          v_attachments = v_file_items.all? do |k, v|
            file = v["file"]
            fa = FormAnswerAttachment.find_by_id(file)
            att_present = fa.present?

            if att_present
              puts "        | Attachment #{fa.id} is VALID"
            else
              puts "        | ERROR: Attachment #{file} is not exist!"
            end

            att_present
          end

          if v_attachments
            puts "        | all attachments are valid!"
          else
            puts "        | ERROR: some attachments invalid!"
          end
        end
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

            form.document["innovation_materials"] = selected_version
            form.save!

            @corrected_ids << form.id

            puts "|||||||||||||||||||||||||||||||||||||||||||||||||||"
            puts ""
            puts "   #{form.id} SAVED!"
            puts ""
            puts "|||||||||||||||||||||||||||||||||||||||||||||||||||"
            puts ""

            sleep 10

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

      @corrected_ids
    end
  end
end
