=begin

  This model is used to test:

    - ActsAsTree
    - Default Scope

=end

class Page < ActiveRecord::Base

  acts_as_tree

  default_scope where(:status => true)

end
