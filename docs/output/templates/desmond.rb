##
# Rails Application Template with:
#
# - Typus with authentication.
# - CMS module and extras if you have access to the private repositories.
# - Themes.
# - CKEditor for textarea fields.
#
# Run:
#
#     $ rails new rails-app-desmond -m http://core.typuscms.com/templates/desmond.rb
#
##

# Add gems to Gemfile.
apply "http://core.typuscms.com/templates/extras/gems.rb"

# Run generators.
apply "http://core.typuscms.com/templates/extras/private.rb"

# Run `typus` generators.
generate "typus"
generate "typus:migration"
rake "db:migrate"

# Load extra templates.
apply "http://core.typuscms.com/templates/extras/ckeditor.rb"
apply "http://core.typuscms.com/templates/extras/themes.rb"
