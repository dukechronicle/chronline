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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140316224623) do

  create_table "articles", :force => true do |t|
    t.text     "body"
    t.string   "subtitle"
    t.string   "section"
    t.string   "teaser"
    t.string   "title"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "slug"
    t.integer  "image_id"
    t.string   "previous_id"
    t.datetime "published_at"
    t.boolean  "block_bots",   :default => false
    t.string   "type"
    t.string   "embed_code"
  end

  add_index "articles", ["section", "published_at"], :name => "index_articles_on_section_and_published_at"
  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true

  create_table "blog_series", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "image_id"
    t.string   "blog_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_series", ["tag_id"], :name => "index_blog_series_on_tag_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "galleries", :id => false, :force => true do |t|
    t.string   "gid"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.date     "date"
  end

  add_index "galleries", ["slug"], :name => "index_galleries_on_slug", :unique => true

  create_table "gallery_images", :id => false, :force => true do |t|
    t.string   "pid"
    t.string   "gid"
    t.text     "caption"
    t.string   "credit"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gallery_images", ["gid", "pid"], :name => "index_gallery_images_on_gid_and_pid", :unique => true

  create_table "images", :force => true do |t|
    t.string   "caption",               :limit => 500
    t.string   "location"
    t.string   "original_file_name"
    t.string   "original_content_type"
    t.integer  "original_file_size"
    t.datetime "original_updated_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "photographer_id"
    t.date     "date"
    t.string   "credit"
    t.string   "attribution"
  end

  add_index "images", ["date"], :name => "index_images_on_date"
  add_index "images", ["photographer_id"], :name => "index_images_on_photographer_id"

  create_table "pages", :force => true do |t|
    t.text     "layout_data"
    t.string   "layout_template"
    t.string   "path"
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "description"
    t.integer  "image_id"
  end

  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true

  create_table "poll_choices", :force => true do |t|
    t.integer  "poll_id"
    t.string   "title"
    t.integer  "votes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "section"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts_authors", :force => true do |t|
    t.integer "post_id"
    t.integer "staff_id"
  end

  add_index "posts_authors", ["post_id", "staff_id"], :name => "index_articles_authors_on_article_id_and_author_id", :unique => true
  add_index "posts_authors", ["post_id"], :name => "index_articles_authors_on_article_id"
  add_index "posts_authors", ["staff_id"], :name => "index_articles_authors_on_author_id"

  create_table "staff", :force => true do |t|
    t.string   "affiliation"
    t.text     "biography"
    t.boolean  "columnist"
    t.string   "name"
    t.string   "tagline"
    t.string   "twitter"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "headshot_id"
  end

  add_index "staff", ["columnist"], :name => "index_staff_on_columnist"
  add_index "staff", ["name"], :name => "index_staff_on_name", :unique => true
  add_index "staff", ["slug"], :name => "index_staff_on_slug", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topic_responses", :force => true do |t|
    t.integer  "topic_id"
    t.boolean  "approved",   :default => false
    t.boolean  "reported",   :default => false
    t.integer  "upvotes",    :default => 0
    t.integer  "downvotes",  :default => 0
    t.string   "content"
    t.float    "score"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "archived",    :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "tournament_brackets", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.text     "picks"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "tournament_brackets", ["tournament_id", "user_id"], :name => "index_tournament_brackets_on_tournament_id_and_user_id", :unique => true

  create_table "tournament_games", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.integer  "score1"
    t.integer  "score2"
    t.integer  "position"
    t.datetime "start_time"
    t.boolean  "final",         :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "tournament_games", ["tournament_id", "position"], :name => "index_tournament_games_on_tournament_id_and_position", :unique => true

  create_table "tournament_teams", :force => true do |t|
    t.string   "school"
    t.string   "shortname"
    t.string   "mascot"
    t.integer  "seed"
    t.integer  "region_id"
    t.integer  "espn_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "preview"
    t.integer  "article_id"
  end

  add_index "tournament_teams", ["tournament_id", "region_id", "seed"], :name => "index_tournament_teams_on_tournament_id_and_region_id_and_seed", :unique => true
  add_index "tournament_teams", ["tournament_id"], :name => "index_tournament_teams_on_tournament_id"

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.string   "event"
    t.datetime "start_date"
    t.text     "challenge_text"
    t.string   "slug"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tournaments", ["slug"], :name => "index_tournaments_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "facebook_uid"
    t.string   "google_uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
