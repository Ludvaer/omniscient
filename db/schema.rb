# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_28_122532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_activations", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "activated", default: false
    t.index ["user_id"], name: "index_account_activations_on_user_id"
  end

  create_table "password_resets", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
  end

  create_table "shultes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "time"
    t.integer "mistakes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "size"
    t.decimal "shuffle"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "downame"
    t.boolean "activated", default: false
    t.index ["downame"], name: "index_users_on_downame", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
