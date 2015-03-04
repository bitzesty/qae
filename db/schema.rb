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

ActiveRecord::Schema.define(version: 20150304145423) do

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

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
  end

  add_index "assessors", ["confirmation_token"], name: "index_assessors_on_confirmation_token", unique: true, using: :btree
  add_index "assessors", ["email"], name: "index_assessors_on_email", unique: true, using: :btree
  add_index "assessors", ["reset_password_token"], name: "index_assessors_on_reset_password_token", unique: true, using: :btree

  create_table "audit_certificates", force: :cascade do |t|
    t.integer  "form_answer_id"
    t.string   "attachment"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "audit_certificates", ["form_answer_id"], name: "index_audit_certificates_on_form_answer_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.text     "body",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorable_type",  null: false
    t.integer  "authorable_id",    null: false
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

  create_table "form_answer_attachments", force: :cascade do |t|
    t.integer  "form_answer_id"
    t.text     "file"
    t.text     "original_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
  end

  add_index "form_answer_attachments", ["form_answer_id"], name: "index_form_answer_attachments_on_form_answer_id", using: :btree

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
    t.hstore   "document"
    t.string   "award_type"
    t.boolean  "withdrawn",               default: false
    t.integer  "account_id"
    t.string   "urn"
    t.boolean  "submitted",               default: false
    t.float    "fill_progress"
    t.boolean  "importance_flag",         default: false
    t.string   "state",                   default: "in_progress1", null: false
    t.string   "company_or_nominee_name"
    t.integer  "award_year"
    t.string   "nominee_full_name"
    t.string   "user_full_name"
    t.string   "award_type_full_name"
    t.string   "sic_code"
  end

  add_index "form_answers", ["account_id"], name: "index_form_answers_on_account_id", using: :btree
  add_index "form_answers", ["user_id"], name: "index_form_answers_on_user_id", using: :btree

  create_table "support_letter_attachments", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "form_answer_id",    null: false
    t.string   "attachment"
    t.string   "original_filename"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "support_letter_id"
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
    t.text     "relationship_to_nominee"
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

  add_index "supporters", ["form_answer_id"], name: "index_supporters_on_form_answer_id", using: :btree
  add_index "supporters", ["user_id"], name: "index_supporters_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
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
    t.boolean  "subscribed_to_emails",       default: false
    t.string   "qae_info_source"
    t.string   "qae_info_source_other"
    t.integer  "account_id"
    t.string   "role"
    t.boolean  "completed_registration",     default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "support_letter_attachments", "form_answers"
  add_foreign_key "support_letter_attachments", "support_letters"
  add_foreign_key "support_letter_attachments", "users"
  add_foreign_key "support_letters", "form_answers"
  add_foreign_key "support_letters", "users"
  add_foreign_key "supporters", "users"
end
