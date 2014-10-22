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

ActiveRecord::Schema.define(version: 20141022204606) do

  create_table "shortened_urls", force: true do |t|
    t.string   "long_url",   null: false
    t.string   "short_url",  null: false
    t.string   "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["long_url", "short_url"], name: "index_shortened_urls_on_long_url_and_short_url"
  add_index "shortened_urls", ["short_url", "user_id"], name: "index_shortened_urls_on_short_url_and_user_id", unique: true

  create_table "users", force: true do |t|
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
