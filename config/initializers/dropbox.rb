Dropbox::API::Config.app_key    = ENV['DROPBOX_APP_KEY']
Dropbox::API::Config.app_secret = ENV['DROPBOX_APP_SECRET']
Dropbox::API::Config.mode       = "sandbox" # if you have a single-directory app
# Dropbox::API::Config.mode       = "dropbox" # if your app has access to the whole dropbox