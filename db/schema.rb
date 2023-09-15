# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[6.1].define(version: 20160607172315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                   default: "",    null: false
    t.string   "encrypted_password",      default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "authy_id"
    t.datetime "last_sign_in_with_authy"
    t.boolean  "authy_enabled",           default: false
    t.integer  "failed_attempts",         default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admins", ["authy_id"], name: "index_admins_on_authy_id", using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "assessor_assignments", force: :cascade do |t|
    t.integer  "form_answer_id",             null: false
    t.integer  "assessor_id"
    t.integer  "position",       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "document"
    t.datetime "submitted_at"
    t.string   "editable_type"
    t.integer  "editable_id"
    t.datetime "assessed_at"
    t.datetime "locked_at"
  end

  add_index "assessor_assignments", ["assessor_id", "form_answer_id"], name: "index_assessor_assignments_on_assessor_id_and_form_answer_id", unique: true, using: :btree
  add_index "assessor_assignments", ["form_answer_id", "position"], name: "index_assessor_assignments_on_form_answer_id_and_position", unique: true, using: :btree

  create_table "assessors", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "trade_role"
    t.string   "innovation_role"
    t.string   "development_role"
    t.string   "promotion_role"
    t.string   "telephone_number"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "company"
    t.string   "mobility_role"
  end

  add_index "assessors", ["confirmation_token"], name: "index_assessors_on_confirmation_token", unique: true, using: :btree
  add_index "assessors", ["email"], name: "index_assessors_on_email", unique: true, using: :btree
  add_index "assessors", ["reset_password_token"], name: "index_assessors_on_reset_password_token", unique: true, using: :btree
  add_index "assessors", ["unlock_token"], name: "index_assessors_on_unlock_token", unique: true, using: :btree

  create_table "audit_certificates", force: :cascade do |t|
    t.integer  "form_answer_id",          null: false
    t.string   "attachment"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "changes_description"
    t.string   "reviewable_type"
    t.integer  "reviewable_id"
    t.datetime "reviewed_at"
    t.integer  "status"
    t.string   "attachment_scan_results"
  end

  add_index "audit_certificates", ["form_answer_id"], name: "index_audit_certificates_on_form_answer_id", using: :btree

  create_table "award_years", force: :cascade do |t|
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "award_years", ["year"], name: "index_award_years_on_year", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",                   null: false
    t.string   "commentable_type",                 null: false
    t.text     "body",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorable_type",                  null: false
    t.integer  "authorable_id",                    null: false
    t.integer  "section",                          null: false
    t.boolean  "flagged",          default: false
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree

  create_table "deadlines", force: :cascade do |t|
    t.string   "kind"
    t.datetime "trigger_at"
    t.integer  "settings_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "states_triggered_at"
  end

  add_index "deadlines", ["settings_id"], name: "index_deadlines_on_settings_id", using: :btree

  create_table "draft_notes", force: :cascade do |t|
    t.text     "content"
    t.string   "notable_type",       null: false
    t.integer  "notable_id",         null: false
    t.string   "authorable_type",    null: false
    t.integer  "authorable_id",      null: false
    t.datetime "content_updated_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eligibilities", force: :cascade do |t|
    t.integer  "account_id"
    t.hstore   "answers"
    t.boolean  "passed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "form_answer_id"
  end

  add_index "eligibilities", ["account_id"], name: "index_eligibilities_on_account_id", using: :btree
  add_index "eligibilities", ["form_answer_id"], name: "index_eligibilities_on_form_answer_id", using: :btree

  create_table "email_notifications", force: :cascade do |t|
    t.string   "kind"
    t.boolean  "sent"
    t.datetime "trigger_at"
    t.integer  "settings_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "email_notifications", ["settings_id"], name: "index_email_notifications_on_settings_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "form_answer_id"
    t.boolean  "submitted",       default: false
    t.hstore   "document"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "authorable_type"
    t.integer  "authorable_id"
    t.datetime "locked_at"
  end

  add_index "feedbacks", ["form_answer_id"], name: "index_feedbacks_on_form_answer_id", using: :btree

  create_table "form_answer_attachments", force: :cascade do |t|
    t.integer  "form_answer_id"
    t.text     "file"
    t.text     "original_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "title"
    t.boolean  "restricted_to_admin", default: false
    t.string   "question_key"
    t.string   "file_scan_results"
  end

  add_index "form_answer_attachments", ["form_answer_id"], name: "index_form_answer_attachments_on_form_answer_id", using: :btree

  create_table "form_answer_progresses", force: :cascade do |t|
    t.hstore  "sections"
    t.integer "form_answer_id", null: false
  end

  add_index "form_answer_progresses", ["form_answer_id"], name: "index_form_answer_progresses_on_form_answer_id", unique: true, using: :btree

  create_table "form_answer_transitions", force: :cascade do |t|
    t.string   "to_state",                      null: false
    t.text     "metadata",       default: "{}"
    t.integer  "sort_key",                      null: false
    t.integer  "form_answer_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_answer_transitions", ["form_answer_id"], name: "index_form_answer_transitions_on_form_answer_id", using: :btree
  add_index "form_answer_transitions", ["sort_key", "form_answer_id"], name: "index_form_answer_transitions_on_sort_key_and_form_answer_id", unique: true, using: :btree

  create_table "form_answers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "award_type"
    t.integer  "account_id"
    t.string   "urn"
    t.boolean  "submitted",                     default: false
    t.float    "fill_progress"
    t.string   "state",                         default: "eligibility_in_progress", null: false
    t.string   "company_or_nominee_name"
    t.string   "nominee_full_name"
    t.string   "user_full_name"
    t.string   "award_type_full_name"
    t.string   "sic_code"
    t.string   "nickname"
    t.hstore   "financial_data"
    t.boolean  "accepted",                      default: false
    t.datetime "company_details_updated_at"
    t.integer  "award_year_id",                                                     null: false
    t.integer  "company_details_editable_id"
    t.string   "company_details_editable_type"
    t.integer  "primary_assessor_id"
    t.integer  "secondary_assessor_id"
    t.json     "document"
    t.string   "nominee_title"
    t.string   "nominator_full_name"
    t.string   "nominator_email"
    t.string   "user_email"
    t.boolean  "corp_responsibility_reviewed",  default: false
    t.string   "pdf_version"
    t.integer  "mobility_eligibility_id"
    t.datetime "submitted_at"
  end

  add_index "form_answers", ["account_id"], name: "index_form_answers_on_account_id", using: :btree
  add_index "form_answers", ["award_year_id"], name: "index_form_answers_on_award_year_id", using: :btree
  add_index "form_answers", ["user_id"], name: "index_form_answers_on_user_id", using: :btree

  create_table "palace_attendees", force: :cascade do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_name"
    t.string   "post_nominals"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_3"
    t.string   "address_4"
    t.string   "postcode"
    t.string   "phone_number"
    t.text     "additional_info"
    t.integer  "palace_invite_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "palace_attendees", ["palace_invite_id"], name: "index_palace_attendees_on_palace_invite_id", using: :btree

  create_table "palace_invites", force: :cascade do |t|
    t.string   "email"
    t.integer  "form_answer_id"
    t.string   "token"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "submitted",      default: false
  end

  add_index "palace_invites", ["form_answer_id"], name: "index_palace_invites_on_form_answer_id", using: :btree

  create_table "press_summaries", force: :cascade do |t|
    t.integer  "form_answer_id",                      null: false
    t.text     "body"
    t.text     "comment"
    t.boolean  "approved",            default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.boolean  "correct"
    t.string   "token"
    t.string   "authorable_type"
    t.integer  "authorable_id"
    t.boolean  "submitted",           default: false
    t.boolean  "applicant_submitted", default: false
    t.boolean  "admin_sign_off",      default: false
  end

  add_index "press_summaries", ["form_answer_id"], name: "index_press_summaries_on_form_answer_id", using: :btree

  create_table "previous_wins", force: :cascade do |t|
    t.integer  "form_answer_id", null: false
    t.string   "category"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scans", force: :cascade do |t|
    t.string   "uuid",                         null: false
    t.string   "filename"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_answer_attachment_id"
    t.integer  "support_letter_attachment_id"
    t.integer  "audit_certificate_id"
    t.string   "vs_id"
  end

  add_index "scans", ["uuid"], name: "index_scans_on_uuid", unique: true, using: :btree

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "award_year_id", null: false
  end

  add_index "settings", ["award_year_id"], name: "index_settings_on_award_year_id", unique: true, using: :btree

  create_table "site_feedbacks", force: :cascade do |t|
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_letter_attachments", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "form_answer_id",          null: false
    t.string   "attachment"
    t.string   "original_filename"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "support_letter_id"
    t.string   "attachment_scan_results"
  end

  add_index "support_letter_attachments", ["form_answer_id"], name: "index_support_letter_attachments_on_form_answer_id", using: :btree
  add_index "support_letter_attachments", ["support_letter_id"], name: "index_support_letter_attachments_on_support_letter_id", using: :btree
  add_index "support_letter_attachments", ["user_id"], name: "index_support_letter_attachments_on_user_id", using: :btree

  create_table "support_letters", force: :cascade do |t|
    t.integer  "supporter_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "form_answer_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization_name"
    t.string   "phone"
    t.string   "relationship_to_nominee"
    t.string   "address_first"
    t.string   "address_second"
    t.string   "city"
    t.string   "country"
    t.string   "postcode"
    t.boolean  "manual",                  default: false
  end

  add_index "support_letters", ["form_answer_id"], name: "index_support_letters_on_form_answer_id", using: :btree
  add_index "support_letters", ["supporter_id"], name: "index_support_letters_on_supporter_id", using: :btree
  add_index "support_letters", ["user_id"], name: "index_support_letters_on_user_id", using: :btree

  create_table "supporters", force: :cascade do |t|
    t.integer  "form_answer_id"
    t.string   "email"
    t.string   "access_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relationship_to_nominee"
  end

  add_index "supporters", ["access_key"], name: "index_supporters_on_access_key", using: :btree
  add_index "supporters", ["form_answer_id"], name: "index_supporters_on_form_answer_id", using: :btree
  add_index "supporters", ["user_id"], name: "index_supporters_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           default: "",    null: false
    t.string   "encrypted_password",                              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "phone_number"
    t.string   "company_name"
    t.string   "company_address_first"
    t.string   "company_address_second"
    t.string   "company_city"
    t.string   "company_country"
    t.string   "company_postcode"
    t.string   "company_phone_number"
    t.string   "prefered_method_of_contact"
    t.boolean  "subscribed_to_emails",                            default: false
    t.string   "qae_info_source"
    t.string   "qae_info_source_other"
    t.integer  "account_id"
    t.string   "role"
    t.boolean  "completed_registration",                          default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "agree_being_contacted_by_department_of_business", default: false
    t.boolean  "imported",                                        default: false
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_line3"
    t.string   "postcode"
    t.string   "phone_number2"
    t.string   "mobile_number"
    t.integer  "failed_attempts",                                 default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.json     "object"
    t.json     "object_changes"
    t.datetime "created_at"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "feedbacks", "form_answers"
  add_foreign_key "palace_attendees", "palace_invites"
  add_foreign_key "palace_invites", "form_answers"
  add_foreign_key "press_summaries", "form_answers"
  add_foreign_key "support_letter_attachments", "form_answers"
  add_foreign_key "support_letter_attachments", "support_letters"
  add_foreign_key "support_letter_attachments", "users"
  add_foreign_key "support_letters", "form_answers"
  add_foreign_key "support_letters", "users"
  add_foreign_key "supporters", "users"
end
