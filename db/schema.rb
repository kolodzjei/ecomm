# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_321_180_959) do
  create_table 'carts', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_carts_on_user_id'
  end

  create_table 'items', force: :cascade do |t|
    t.integer 'quantity', default: 1
    t.integer 'cart_id'
    t.integer 'product_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['cart_id'], name: 'index_items_on_cart_id'
    t.index ['product_id'], name: 'index_items_on_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'description', null: false
    t.decimal 'price', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'name', null: false
    t.string 'password_digest', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'confirmed_at'
    t.string 'unconfirmed_email'
    t.string 'remember_token', null: false
    t.boolean 'admin', default: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['remember_token'], name: 'index_users_on_remember_token', unique: true
  end

  add_foreign_key 'carts', 'users'
  add_foreign_key 'items', 'carts'
  add_foreign_key 'items', 'products'
end
