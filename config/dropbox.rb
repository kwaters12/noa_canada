# Dropbox::API::Config.app_key    = ENV['DROPBOX_APP_KEY']
# Dropbox::API::Config.app_secret = ENV['DROPBOX_APP_SECRET']
# Dropbox::API::Config.mode       = "sandbox" # if you have a single-directory app
# # Dropbox::API::Config.mode       = "dropbox" # if your app has access to the whole dropbox

require 'dropbox_sdk'
DROPBOX_APP_KEY = ENV['DROPBOX_APP_KEY'] #replace with your own app key
DROPBOX_APP_KEY_SECRET = ENV['DROPBOX_APP_SECRET'] #replace with your own key secret
DROPBOX_APP_MODE = "dropbox"