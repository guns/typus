=begin

Generate a Rails application with typus, typus_cms and typus_settings.

    $ rails new desmond -m http://core.typuscms.com/desmond.rb

Enjoy!

=end

##
# Install typus & friends
#

gem 'acts_as_list'
gem 'acts_as_tree'
gem 'paperclip'
gem 'typus', :git => "https://github.com/fesplugas/typus.git"

##
# Update the bundle
#

run 'bundle install'

##
# Create typus related files ...
#

generate "typus"
generate "typus:migration"

##
# Install typus extras only if user has access to trunksapp.com
#

answer = ask("Do you have access to trunksapp.com? (yes/NO)").downcase
extras = (answer == "yes" || answer == "y") ? true : false

if extras
  plugin "typus_cms", :git => "git@trunksapp.com:fesplugas/typus_cms.git"
  plugin "typus_settings", :git => "git@trunksapp.com:fesplugas/typus_settings.git"
  generate "typus_cms_migration"
  generate "typus_settings_migration"
end

##
# Migrate the database!
#

rake "db:migrate"
