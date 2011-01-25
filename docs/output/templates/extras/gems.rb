##
# You can apply this template to your existing project by running:
#
#     $ rake rails:template LOCATION=http://core.typuscms.com/templates/extras/gems.rb
#

gem 'acts_as_list'
gem 'acts_as_tree'
gem 'acts_as_trashable', :git => 'https://github.com/fesplugas/rails-acts_as_trashable.git'
gem 'dragonfly', '~>0.8.1'
gem 'permalink', :git => 'https://github.com/fesplugas/rails-permalink.git'
gem 'typus', :git => "https://github.com/fesplugas/typus.git"
gem 'rack-cache', :require => 'rack/cache'

run "bundle install"
