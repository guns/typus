Factory.define :asset do |f|
  f.caption "Caption"
end

Factory.define :category do |f|
  f.name "Category"
end

Factory.define :comment do |f|
  f.name "John"
  f.email "john@example.com"
  f.body "Body of the comment"
  f.association :post
end

Factory.define :page do |f|
  f.title "Title"
  f.body "Content"
  f.status "published"
end

Factory.define :picture do |f|
  f.title "Some picture"
  f.picture_file_name "dog.jpg"
  f.picture_content_type "image/jpeg"
  f.picture_file_size "175938"
  f.picture_updated_at 3.days.ago.to_s(:db)
end

Factory.define :post do |f|
  f.title "Post"
  f.body "Body"
  f.status "published"
end

Factory.define :typus_user do |f|
  f.email "admin@example.com"
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
  f.preferences Hash.new({ :locale => :en })
end
