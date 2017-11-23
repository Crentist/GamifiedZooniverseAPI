class User < ApplicationRecord
  has_many :collaborations
  has_many :projects, through: :collaborations
  has_many :owned_projects, :class_name => 'Project'
  has_and_belongs_to_many :badges, optional: true
  has_many :project_badges, through: :project


  #validates :zooniverseHandle
  validates :zooniverseHandle, presence: { message: "zooniverseHandle can't be blank" }, uniqueness: { message: "zooniverseHandle must be unique"}

  def classification_count
    #global amount of classifications. Generic, non-project badge
    collaborations.sum {|c| c.classification_count }
  end

end
