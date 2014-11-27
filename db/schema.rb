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

ActiveRecord::Schema.define(version: 20141127071022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "answers", force: true do |t|
    t.integer  "form_response_id"
    t.integer  "question_id"
    t.integer  "question_option_id"
    t.string   "input"
    t.text     "area"
    t.date     "date_value"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["form_response_id"], name: "index_answers_on_form_response_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["question_option_id"], name: "index_answers_on_question_option_id", using: :btree

  create_table "form_responses", force: true do |t|
    t.integer  "form_id"
    t.integer  "user_id"
    t.string   "devise_type"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_responses", ["form_id"], name: "index_form_responses_on_form_id", using: :btree
  add_index "form_responses", ["user_id"], name: "index_form_responses_on_user_id", using: :btree

  create_table "form_steps", force: true do |t|
    t.integer  "form_id"
    t.string   "title"
    t.text     "description"
    t.text     "note"
    t.integer  "placement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_steps", ["form_id"], name: "index_form_steps_on_form_id", using: :btree

  create_table "forms", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_options", force: true do |t|
    t.integer  "question_id"
    t.text     "title"
    t.text     "input"
    t.boolean  "with_input"
    t.integer  "placement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "form_step_id"
    t.integer  "question_id"
    t.string   "title"
    t.text     "description"
    t.string   "element_type"
    t.integer  "placement"
    t.text     "note_above"
    t.text     "note_below"
    t.text     "hint_above"
    t.text     "hint_below"
    t.boolean  "visible"
    t.boolean  "is_subquestion"
    t.boolean  "is_optional"
    t.string   "css_class"
    t.integer  "css_size"
    t.boolean  "chars_limited"
    t.string   "view_template_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["form_step_id"], name: "index_questions_on_form_step_id", using: :btree
  add_index "questions", ["question_id"], name: "index_questions_on_question_id", using: :btree

  create_table "users", force: true do |t|
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
