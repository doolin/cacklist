# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cacklist_session',
  :secret      => '446b08b16e122fddc266da6c93781d9c7b69a4fe95a271a0c61275e3167b20b612319798e0c14ee8860b60b5d26b60ac0c53d4b32e8cb3d523218422d412764f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
