##
# Rails Application Template with:
#
# - Typus with authentication.
# - CMS models.
# - Themes.
# - CKEditor for textarea fields.
#
# Run:
#
#     $ rails new rails-app-cms -m http://core.typuscms.com/templates/cms.rb
#
##

# Add gems to Gemfile.
apply "http://core.typuscms.com/templates/extras/gems.rb"

# Run generators.
apply "http://core.typuscms.com/templates/extras/cms.rb"

# Run `typus` generators.
generate "typus"
generate "typus:migration"
rake "db:migrate"

# Load extra templates.
apply "http://core.typuscms.com/templates/extras/ckeditor.rb"
apply "http://core.typuscms.com/templates/extras/themes.rb"
