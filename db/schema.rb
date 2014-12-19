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

ActiveRecord::Schema.define(version: 20141219102035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id", using: :btree

  create_table "admins", force: true do |t|
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
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "eligibilities", force: true do |t|
    t.integer  "user_id"
    t.hstore   "answers"
    t.boolean  "passed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "form_answer_id"
  end

  add_index "eligibilities", ["form_answer_id"], name: "index_eligibilities_on_form_answer_id", using: :btree
  add_index "eligibilities", ["user_id"], name: "index_eligibilities_on_user_id", using: :btree

  create_table "form_answer_attachments", force: true do |t|
    t.integer  "form_answer_id"
    t.text     "file"
    t.text     "original_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_answer_attachments", ["form_answer_id"], name: "index_form_answer_attachments_on_form_answer_id", using: :btree

  create_table "form_answers", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "document"
    t.string   "award_type"
    t.boolean  "withdrawn",     default: false
    t.integer  "account_id"
    t.string   "urn"
    t.boolean  "submitted"
    t.float    "fill_progress"
  end

  add_index "form_answers", ["account_id"], name: "index_form_answers_on_account_id", using: :btree
  add_index "form_answers", ["user_id"], name: "index_form_answers_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
