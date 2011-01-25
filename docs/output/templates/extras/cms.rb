##
# You can apply this template to your existing project by running:
#
#     $ rake rails:template LOCATION=http://core.typuscms.com/templates/extras/cms.rb
#

generate(:model, "Entry", "title:string", "permalink:string", "content:text", "excerpt:text", "published:boolean", "type:string")

rake "db:migrate"
