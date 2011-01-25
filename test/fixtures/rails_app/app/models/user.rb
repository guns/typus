class User < ActiveRecord::Base

  has_many :projects, :dependent => :destroy
  has_many :third_party_projects, :through => :project_collaborators, :dependent => :destroy

end
