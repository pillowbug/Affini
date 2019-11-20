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

ActiveRecord::Schema.define(version: 2019_11_19_050545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.bigint "checkin_id"
    t.bigint "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkin_id"], name: "index_attendees_on_checkin_id"
    t.index ["connection_id"], name: "index_attendees_on_connection_id"
  end

  create_table "checkins", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "rating"
    t.datetime "time"
    t.text "description"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_checkins_on_user_id"
  end

  create_table "checkins_connections", force: :cascade do |t|
    t.bigint "checkin_id"
    t.bigint "connection_id"
    t.index ["checkin_id"], name: "index_checkins_connections_on_checkin_id"
    t.index ["connection_id"], name: "index_checkins_connections_on_connection_id"
  end

  create_table "connection_tags", force: :cascade do |t|
    t.bigint "connection_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["connection_id"], name: "index_connection_tags_on_connection_id"
    t.index ["tag_id"], name: "index_connection_tags_on_tag_id"
  end

  create_table "connections", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "description"
    t.date "birthday"
    t.string "frequency"
    t.string "email"
    t.string "facebook"
    t.string "linkedin"
    t.string "phone_number"
    t.string "instagram"
    t.string "twitter"
    t.string "photo"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "connections_tags", force: :cascade do |t|
    t.bigint "connection_id"
    t.bigint "tag_id"
    t.index ["connection_id"], name: "index_connections_tags_on_connection_id"
    t.index ["tag_id"], name: "index_connections_tags_on_tag_id"
  end

  create_table "glances", force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.bigint "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["connection_id"], name: "index_glances_on_connection_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "photo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendees", "checkins"
  add_foreign_key "attendees", "connections"
  add_foreign_key "checkins", "users"
  add_foreign_key "checkins_connections", "checkins"
  add_foreign_key "checkins_connections", "connections"
  add_foreign_key "connection_tags", "connections"
  add_foreign_key "connection_tags", "tags"
  add_foreign_key "connections", "users"
  add_foreign_key "connections_tags", "connections"
  add_foreign_key "connections_tags", "tags"
  add_foreign_key "glances", "connections"
end
