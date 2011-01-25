source 'http://rubygems.org'

gemspec

gem "acts_as_list"
gem "acts_as_tree"
gem "dragonfly", "~>0.8.1"
gem "factory_girl"

group :test do
  gem "mysql"
  gem "pg"
end

gem "paperclip"

gem "rack-cache", :require => "rack/cache"
gem "rails", "~> 3.0"

gem 'sqlite3-ruby', '1.2.1'

# Keep this here because I use it as reference for development.
gem "fastercsv", "1.5.3" if RUBY_VERSION < '1.9'
gem "render_inheritable"
gem "will_paginate", "~> 3.0.pre2"

group :test do
  gem "shoulda"
  gem "tartare", :git => "https://github.com/fesplugas/rails-tartare.git", :require => false
  gem "mocha"
end
