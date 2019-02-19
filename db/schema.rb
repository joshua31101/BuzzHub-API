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

ActiveRecord::Schema.define(version: 2019_02_21_072220) do

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "number", limit: 2
    t.string "d_abbr", limit: 5
    t.string "name"
    t.integer "hours", limit: 1
    t.text "desc"
    t.float "avg_gpa"
    t.integer "gpa_a", limit: 1
    t.integer "gpa_b", limit: 1
    t.integer "gpa_c", limit: 1
    t.integer "gpa_d", limit: 1
    t.integer "gpa_f", limit: 1
    t.integer "gpa_w", limit: 1
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_courses_on_department_id"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "abbr", limit: 5
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lecturers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_lecturers_on_first_name_and_last_name", unique: true
  end

  create_table "managed_courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "year", limit: 2
    t.integer "semester", limit: 1
    t.float "avg_gpa"
    t.integer "gpa_a", limit: 1
    t.integer "gpa_b", limit: 1
    t.integer "gpa_c", limit: 1
    t.integer "gpa_d", limit: 1
    t.integer "gpa_f", limit: 1
    t.integer "gpa_w", limit: 1
    t.bigint "lecturer_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_managed_courses_on_course_id"
    t.index ["lecturer_id"], name: "index_managed_courses_on_lecturer_id"
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "overall", limit: 1
    t.integer "difficulty", limit: 1
    t.text "desc"
    t.integer "year", limit: 2
    t.integer "semester", limit: 1
    t.bigint "managed_course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["managed_course_id"], name: "index_reviews_on_managed_course_id"
  end

end
