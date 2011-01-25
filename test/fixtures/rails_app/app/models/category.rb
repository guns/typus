=begin

  This model is used to test:

    - ActsAsList on resources_controller
    - Relate and unrelate for has_and_belongs_to_many.

=end

class Category < ActiveRecord::Base

  acts_as_list

  has_and_belongs_to_many :entries
  has_and_belongs_to_many :posts

end
