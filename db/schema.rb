ActiveRecord::Schema[7.1].define(version: 2026_04_02_000001) do
  create_table 'microposts', force: :cascade do |t|
    t.string   'content'
    t.integer  'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_microposts_on_user_id'
  end

  create_table 'relationships', force: :cascade do |t|
    t.integer  'follower_id'
    t.integer  'followed_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['followed_id'], name: 'index_relationships_on_followed_id'
    t.index ['follower_id', 'followed_id'], name: 'index_relationships_on_follower_id_and_followed_id', unique: true
    t.index ['follower_id'], name: 'index_relationships_on_follower_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'name'
    t.string   'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string   'password_digest'
    t.boolean  'admin',           default: false
    t.string   'remember_digest'
  end
end
