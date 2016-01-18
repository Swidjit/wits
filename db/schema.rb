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

ActiveRecord::Schema.define(version: 20151229153643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "board_id"
    t.string   "award_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_suggestions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "suggestion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "familiarities", force: :cascade do |t|
    t.integer "user_id",                  null: false
    t.integer "familiar_id",              null: false
    t.integer "familiarness", default: 0, null: false
  end

  add_index "familiarities", ["user_id", "familiar_id"], name: "index_familiarities_on_user_id_and_familiar_id", unique: true, using: :btree

  create_table "flag_votes", force: :cascade do |t|
    t.integer "post_id"
    t.string  "vote"
    t.integer "user_id"
  end

  create_table "game_boards", force: :cascade do |t|
    t.integer  "game_id"
    t.text     "content"
    t.integer  "duration"
    t.datetime "start_date"
    t.string   "status",        default: "queued"
    t.string   "data"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_limit"
  end

  create_table "game_improvements", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "improvement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.float    "pct"
    t.integer  "score"
    t.integer  "board_count"
    t.float    "score_avg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.float    "rating"
    t.integer  "times_played"
    t.integer  "board_count"
    t.string   "logo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_limit"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string "invite_code"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "notifier_id"
    t.string   "notifier_type"
    t.string   "notifier_action"
    t.boolean  "delivered",       default: false
    t.boolean  "read",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_board_id"
    t.string   "body"
    t.integer  "importance",    default: 0
    t.string   "slug"
    t.boolean  "active"
    t.string   "status",        default: "draft"
    t.integer  "score",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reactions", force: :cascade do |t|
    t.string   "reaction_type"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "subscription_id",   null: false
    t.string   "subscription_type", null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "score",                  default: 0
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "first_name"
    t.text     "about"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.string   "vote"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string   "body"
    t.integer  "game_board_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
