namespace :form_answers do
  #
  # bundle exec rake form_answers:force_submit[FORM_ANSWER_ID]
  #
  desc "Force submit an application"
  task :force_submit, [:id] => [:environment] do |t, args|
    form_answer = FormAnswer.find(args[:id])
    ::ManualUpdaters::SubmitApplication.new(form_answer).run!
  end

  desc "Populate submitted_at"
  task populate_submitted_at: :environment do
    current_award_year_id = AwardYear.find_by(year: 2017).id
    current_time = Time.current
    FormAnswer.where(submitted_at: nil).find_each do |f|
      if f.award_year_id == current_award_year_id
        if f.submitted
          f.update_column(:submitted_at, current_time)
          puts "[form answer] #{f.id} updating submitted_at with #{current_time}"
        end
      elsif f.submitted
        f.update_column(:submitted_at, f.created_at)
        puts "[form answer] #{f.id} updating submitted_at with #{f.created_at}"
      end
    end
  end

  desc "populate hard copy PDF version for current award year applications"
  task populate_hard_copy_pdf_version_for_applications: :environment do
    not_updated_entries = []

    AwardYear.current.form_answers.submitted.find_each do |form_answer|
      form_answer.generate_pdf_version!
      sleep 1

      puts "[form_answer]---------------------------------#{form_answer.id} updated"
    rescue
      not_updated_entries << form_answer.id
    end

    puts "[not_updated_entries] ------------ #{not_updated_entries.inspect}"
  end

  desc "fixes eligibility inconsistencies"
  task fix_eligibility: :environment do
    FormAnswer.find_each do |f|
      f.state_machine.perform_transition("not_eligible", nil, false) unless f.eligible?
    end
  end

  desc "populate locked_at for case summary assessor assignments"
  task populate_locked_at_for_case_summaries: :environment do
    AssessorAssignment.submitted.where(position: 4).each do |assignment|
      assignment.update_column(:locked_at, assignment.submitted_at)
    end
  end

  desc "fixes attachment arrays"
  task fix_attachments: :environment do
    FormAnswer.find_each do |f|
      if f.document["innovation_materials"].is_a? Array
        array = f.document["innovation_materials"]
        hash = {}
        array.each_index do |i|
          hash[i.to_s] = array[i]
        end
        f.document["innovation_materials"] = hash
        f.update_column(:document, f.document)
      end
    end
  end

  def replace_key f, new_key, old_key
    f.document[new_key] = f.document.delete(old_key) if f.document[old_key].present?
  end

  def fix_address f, old_key, new_key
    replace_key f, "#{new_key}_building", "#{old_key}_building"
    replace_key f, "#{new_key}_street", "#{old_key}_street"
    replace_key f, "#{new_key}_city", "#{old_key}_city"
    replace_key f, "#{new_key}_county", "#{old_key}_county"
    replace_key f, "#{new_key}_postcode", "#{old_key}_postcode"
    replace_key f, "#{new_key}_region", "#{old_key}_region"
  end

  desc "normalize address fields to use the same fields for different kind of documentss"
  task normalize_address: :environment do
    FormAnswer.find_each do |f|
      fix_address f, "principal_address", "organization_address"
      f.update_column(:document, f.document)
    end
  end

  desc "fixes missing org_chart from document"
  task fix_missing_org_chart: :environment do
    FormAnswerAttachment.where(question_key: "org_chart").find_each do |attachment|
      attachment.form_answer.document["org_chart"] = { "0" => { "file" => attachment.id } }
      attachment.form_answer.save!
    end
  end

  desc "Adds search indexed data"
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

  desc "Creates the urns"
  task create_urns: :environment do
    FormAnswer.connection.execute("CREATE SEQUENCE urn_seq_2016")
    FormAnswer.connection.execute("CREATE SEQUENCE urn_seq_promotion_2016")
  end

  # For single use only
  desc "Rebuilds the urns for all apps"
  task rebuild_urn: :environment do
    FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_2016 RESTART")
    FormAnswer.connection.execute("ALTER SEQUENCE urn_seq_promotion_2016 RESTART")
    FormAnswer.update_all(urn: nil)
    FormAnswer.find_each(&:save!)
  end

  desc "Adds the county/remove country to all form answers"
  task refresh_attributes: :environment do
    FormAnswer.find_each do |f|
      next if f.promotion?
      f.document.delete("principal_address_country")
      f.document["principal_address_county"] = "Buckinghamshire" if f.submitted?
      f.save(validate: false)
    end
  end

  desc "Removes the deprecated answers from forms"
  task remove_overseas_sales: :environment do
    FormAnswer.where(award_type: "trade").find_each do |f|
      attributes = [
        "overseas_sales_direct_1of3",
        "overseas_sales_direct_1of6",
        "overseas_sales_direct_2of3",
        "overseas_sales_direct_3of3",
        "overseas_sales_direct_2of6",
        "overseas_sales_direct_3of6",
        "overseas_sales_direct_4of6",
        "overseas_sales_direct_5of6",
        "overseas_sales_direct_6of6",
        "overseas_sales_indirect_1of3",
        "overseas_sales_indirect_2of3",
        "overseas_sales_indirect_3of3",
        "overseas_sales_indirect_1of6",
        "overseas_sales_indirect_2of6",
        "overseas_sales_indirect_3of6",
        "overseas_sales_indirect_4of6",
        "overseas_sales_indirect_5of6",
        "overseas_sales_indirect_6of6",

      ]
      attributes.each do |a|
        f.document.delete(a)
      end
      f.save(validate: false)
    end
  end

  desc "Resaves company_or_nominee_name field"
  task resave_company_or_nominee_name: :environment do
    FormAnswer.find_each do |f|
      args = {
        company_or_nominee_name: f.company_or_nominee_from_document,
        nominee_full_name: f.nominee_full_name_from_document,
        nominator_full_name: f.send(:nominator_full_name_from_document),
        nominator_email: f.send(:nominator_email_from_document),
      }

      f.update_columns(args)
    end
  end

  desc "Updates user_email field"
  task update_user_email_field: :environment do
    i = 0

    puts "Updating form answers..."
    FormAnswer.find_each do |f|
      if f.user
        f.update_column(:user_email, f.user.email)
        i += 1
      end
    end

    puts "#{i} form answers were updated"
  end

  desc "Migrates data for trade application from 6 to 3 years"
  task :downgrade_trade_to_3_years, [:id] => [:environment] do |t, args|
    form_answer = FormAnswer.find(args[:id])
    ManualUpdaters::TradeAwardDowngrader.new(form_answer).run!
  end

  desc "Fixes misspelt regions/counties within form answers"
  task fix_address_counties: :environment do
    counter = 0
    county_mapper = {
      "Befordshire" => "Bedfordshire",
      "Stafffordshire" => "Staffordshire",
    }

    puts "Updating form answers..."

    keys = %w[personal_address_county nominee_personal_address_county organization_address_county]

    county_mapper.each do |wrong_county, correct_county|
      keys.each do |key|
        FormAnswer.where("document ->> '#{key}' = '#{wrong_county}'").find_each do |answer|
          answer.document[key] = correct_county
          answer.save(validate: false)

          counter += 1
        end
      end
    end

    puts "Fixed #{counter} form answers!"
  end

  desc "Backfill `head_of_business_title` and/or `press_contact_details_title` for all form answers w/ incorrect value"
  task backfill_whitelisted_titles: :environment do
    Rails.logger = Logger.new($stdout)

    t = ::FormAnswer.arel_table
    op1 = Arel::Nodes::InfixOperation.new("->>", t[:document], Arel::Nodes.build_quoted("head_of_business_title"))
    op2 = Arel::Nodes::InfixOperation.new("->>", t[:document], Arel::Nodes.build_quoted("press_contact_details_title"))
    whitelisted_values = ::User::POSSIBLE_TITLES

    query = op1.not.in(whitelisted_values).or(op2.not.in(whitelisted_values))
    scope = ::FormAnswer.for_year(AwardYear.current.year).where(query)

    count = scope.count

    idx = 0
    to_do = Hash[]

    Rails.logger.info "\e[32mCorrecting #{count} records…\e[0m"

    scope.find_each do |record|
      idx += 1

      head_of_business_title = record.document.dig("head_of_business_title")
      press_contact_details_title = record.document.dig("press_contact_details_title")

      next if [head_of_business_title, press_contact_details_title].all?(&:blank?)

      normalized_head_of_business_title = if head_of_business_title.present?
        head_of_business_title.remove(/(\(|\[).*(\)|\])/).scan(/[[:word:]]*/i).join.capitalize
      end

      normalized_press_contact_details_title = if press_contact_details_title.present?
        press_contact_details_title.remove(/(\(|\[).*(\)|\])/).scan(/[[:word:]]*/i).join.capitalize
      end

      if normalized_head_of_business_title.in?(whitelisted_values)
        record.document[:head_of_business_title] = normalized_head_of_business_title
      elsif head_of_business_title.present?
        (to_do[record.id] ||= {})["head_of_business_title"] = head_of_business_title
      end

      if normalized_press_contact_details_title.in?(whitelisted_values)
        record.document[:press_contact_details_title] = normalized_press_contact_details_title
      elsif press_contact_details_title.present?
        (to_do[record.id] ||= {})["press_contact_details_title"] = press_contact_details_title
      end

      record.save(validate: false)

      Rails.logger.info "[#{idx}/#{count}]" if (idx % 10).zero?
    end

    Rails.logger.info "\e[32mRecords to correct:\e[0m"
    to_do.entries.each do |identifier, hash|
      $stdout.puts "#{identifier} ~> #{hash}\n"
    end

    Rails.logger.info "\e[32mCompleted!\e[0m"
  end

  desc "Populate `nickname` field for Innovation and Promoting Opportunity applications"
  task populate_nickname: :environment do
    scope = FormAnswer.where(nickname: nil).where(award_type: FormAnswer::AWARD_TYPES_WITH_NICKNAME_REQUIRED)
    count = scope.count

    idx = 0

    print "\e[32mPopulating nickname for #{count} records…\e[0m"

    scope.find_in_batches(batch_size: 500) do |collection|
      idx += collection.size
      ids = collection.map(&:id).join(",").to_s

      query = %{
        UPDATE form_answers
        SET nickname = CASE WHEN award_type = 'mobility' THEN 'Promoting Opportunity' ELSE 'Innovation' END
        WHERE form_answers.id IN (#{ids})
      }.squish

      ActiveRecord::Base.connection.execute(query)
    end
  end
end
