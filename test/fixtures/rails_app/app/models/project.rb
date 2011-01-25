class Project < ActiveRecord::Base

  belongs_to :user

  has_many :project_collaborators, :dependent => :destroy
  has_many :collaborators, :through => :project_collaborators, :source => :user

end
