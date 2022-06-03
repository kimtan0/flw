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

ActiveRecord::Schema.define(version: 2022_06_03_105440) do

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.date "project_date"
    t.string "project_owner_id"
    t.string "project_type"
    t.string "project_description"
    t.string "project_status"
    t.string "project_milestone"
    t.string "project_acceptance_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "project_category"
    t.string "project_detailed_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.string "postcode"
    t.string "phone_number"
    t.string "country"
    t.boolean "employer_status", default: false
    t.boolean "freelancer_status", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

end
