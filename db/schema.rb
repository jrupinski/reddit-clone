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

ActiveRecord::Schema[7.0].define(version: 2022_06_27_145430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_comment_id"
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "post_subs", force: :cascade do |t|
    t.bigint "sub_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_subs_on_post_id"
    t.index ["sub_id", "post_id"], name: "index_post_subs_on_sub_id_and_post_id", unique: true
    t.index ["sub_id"], name: "index_post_subs_on_sub_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "url"
    t.text "content"
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "subs", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.bigint "moderator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["moderator_id"], name: "index_subs_on_moderator_id"
    t.index ["name"], name: "index_subs_on_name", unique: true
    t.index ["slug"], name: "index_subs_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "session_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type", null: false
    t.bigint "votable_id", null: false
    t.bigint "user_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "votable_id", "votable_type"], name: "index_votes_on_user_id_and_votable_id_and_votable_type", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "post_subs", "posts"
  add_foreign_key "post_subs", "subs"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "subs", "users", column: "moderator_id"
  add_foreign_key "votes", "users"
end
