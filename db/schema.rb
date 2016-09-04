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

ActiveRecord::Schema.define(version: 20160303131020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "carriers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "logo_url"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_order"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "sic_code"
    t.date     "effective_date"
    t.integer  "proposal_duration"
    t.integer  "state",             default: 0
    t.text     "selectors"
    t.string   "document_type"
    t.integer  "project_id"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived",       default: false
    t.boolean  "is_sold",           default: false
  end

  add_index "documents", ["carrier_id"], name: "index_documents_on_carrier_id", using: :btree
  add_index "documents", ["project_id"], name: "index_documents_on_project_id", using: :btree

  create_table "dynamic_attributes", force: :cascade do |t|
    t.string   "display_name"
    t.string   "parent_class"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "value_type"
    t.boolean  "required",             default: false
    t.integer  "category_id"
    t.integer  "attribute_order"
    t.boolean  "is_rate",              default: false
    t.hstore   "export_configuration"
  end

  add_index "dynamic_attributes", ["export_configuration"], name: "index_dynamic_attributes_on_export_configuration", using: :gist

  create_table "dynamic_attributes_product_types", id: false, force: :cascade do |t|
    t.integer "dynamic_attribute_id", null: false
    t.integer "product_type_id",      null: false
  end

  add_index "dynamic_attributes_product_types", ["dynamic_attribute_id"], name: "index_dynamic_attributes_product_types_on_dynamic_attribute_id", using: :btree
  add_index "dynamic_attributes_product_types", ["product_type_id"], name: "index_dynamic_attributes_product_types_on_product_type_id", using: :btree

  create_table "dynamic_values", force: :cascade do |t|
    t.integer  "dynamic_attribute_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "value"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "type"
    t.integer  "comparison_flag",      default: 0
    t.string   "selector"
    t.boolean  "is_atp_rate",          default: false, null: false
  end

  add_index "dynamic_values", ["dynamic_attribute_id"], name: "index_dynamic_values_on_dynamic_attribute_id", using: :btree
  add_index "dynamic_values", ["parent_type", "parent_id"], name: "index_dynamic_values_on_parent_type_and_parent_id", using: :btree

  create_table "employers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "sic_code"
    t.integer  "user_id"
  end

  add_index "employers", ["user_id"], name: "index_employers_on_user_id", using: :btree

  create_table "orderings", force: :cascade do |t|
    t.string   "parent_type"
    t.integer  "parent_id"
    t.integer  "order_index",     default: 0
    t.integer  "carrier_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "product_type_id"
  end

  add_index "orderings", ["carrier_id"], name: "index_orderings_on_carrier_id", using: :btree
  add_index "orderings", ["parent_id", "parent_type"], name: "index_orderings_on_parent_id_and_parent_type", using: :btree
  add_index "orderings", ["product_type_id"], name: "index_orderings_on_product_type_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_classes", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "description"
    t.text     "selectors"
    t.integer  "class_number"
  end

  add_index "product_classes", ["product_id"], name: "index_product_classes_on_product_id", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.float    "unit_rate_denominator"
    t.integer  "broker_app_position"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "selectors"
    t.integer  "product_type_id"
    t.boolean  "contributory",    default: true, null: false
    t.integer  "document_id"
  end

  add_index "products", ["document_id"], name: "index_products_on_document_id", using: :btree
  add_index "products", ["product_type_id"], name: "index_products_on_product_type_id", using: :btree

  create_table "project_product_types", force: :cascade do |t|
    t.integer  "project_id",                      null: false
    t.integer  "product_type_id",                 null: false
    t.boolean  "inforce",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "project_product_types", ["product_type_id"], name: "index_project_product_types_on_product_type_id", using: :btree
  add_index "project_product_types", ["project_id"], name: "index_project_product_types_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "employer_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.boolean  "is_archived",    default: false
    t.date     "effective_date"
  end

  add_index "projects", ["employer_id"], name: "index_projects_on_employer_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "review_items", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "key"
    t.integer  "time"
    t.boolean  "did_update"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "review_items", ["parent_id", "parent_type"], name: "index_review_items_on_parent_id_and_parent_type", using: :btree
  add_index "review_items", ["review_id"], name: "index_review_items_on_review_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "proposal_state"
    t.integer  "document_id"
  end

  add_index "reviews", ["document_id"], name: "index_reviews_on_document_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sources", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "raw_html"
    t.integer  "document_id"
  end

  add_index "sources", ["document_id"], name: "index_sources_on_document_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
  end

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "dynamic_values", "dynamic_attributes"
  add_foreign_key "employers", "users"
  add_foreign_key "products", "documents"
  add_foreign_key "products", "product_types"
  add_foreign_key "projects", "employers"
  add_foreign_key "projects", "users"
  add_foreign_key "review_items", "reviews"
  add_foreign_key "reviews", "documents"
  add_foreign_key "sources", "documents"
end
