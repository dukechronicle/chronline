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

ActiveRecord::Schema.define(:version => 20130419063641) do

  create_table "articles", :force => true do |t|
    t.text     "body"
    t.string   "subtitle"
    t.string   "section"
    t.string   "teaser"
    t.string   "title"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "slug"
    t.integer  "image_id"
    t.string   "previous_id"
    t.datetime "published_at"
  end

  add_index "articles", ["section", "published_at"], :name => "index_articles_on_section_and_published_at"
  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true

  create_table "articles_authors", :force => true do |t|
    t.integer "article_id"
    t.integer "staff_id"
  end

  add_index "articles_authors", ["article_id", "staff_id"], :name => "index_articles_authors_on_article_id_and_author_id", :unique => true
  add_index "articles_authors", ["article_id"], :name => "index_articles_authors_on_article_id"
  add_index "articles_authors", ["staff_id"], :name => "index_articles_authors_on_author_id"

  create_table "blog_posts", :force => true do |t|
    t.text     "body"
    t.string   "blog"
    t.string   "title"
    t.string   "slug"
    t.integer  "image_id"
    t.integer  "author_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "published_at"
  end

  add_index "blog_posts", ["author_id"], :name => "index_blog_posts_on_author_id"
  add_index "blog_posts", ["blog", "published_at"], :name => "index_blog_posts_on_blog_and_published_at"
  add_index "blog_posts", ["slug"], :name => "index_blog_posts_on_slug", :unique => true

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

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

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
