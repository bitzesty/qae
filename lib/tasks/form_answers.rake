namespace :form_answers do

  def replace_key f, old_key, new_key
    f.document[new_key] = f.document.delete(old_key) if f.document[old_key].present?
  end

  def fix_address f, old_key, new_key
    replace_key f, "#{new_key}_building", "#{old_key}_building"
    replace_key f, "#{new_key}_street",   "#{old_key}_street"
    replace_key f, "#{new_key}_city",     "#{old_key}_city"
    replace_key f, "#{new_key}_county",   "#{old_key}_county"
    replace_key f, "#{new_key}_postcode", "#{old_key}_postcode"
    replace_key f, "#{new_key}_region",   "#{old_key}_region"
  end

  desc "normalize address fields to use the same fields for different kind of documentss"
  task normalize_address: :environment do
    FormAnswer.find_each do |f|
      fix_address f, "principal_address", "organization_address"
      f.update_column(:document, f.document)
    end
  end

  desc 'fixes missing org_chart from document'
  task fix_missing_org_chart: :environment do
    FormAnswerAttachment.where(question_key: "org_chart").find_each do |attachment|
      attachment.form_answer.document["org_chart"] = { "0" => { "file" => attachment.id } }
      attachment.form_answer.save!
    end
  end

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
        "overseas_sales_indirect_6of6"

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
        nominator_email: f.send(:nominator_email_from_document)
      }

      f.update_columns(args)
    end
  end
end
