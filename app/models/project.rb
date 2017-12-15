class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  has_many :project_badges, through: :collaborations
  belongs_to :user, :optional => true
  has_many :milestones

  validates :name, uniqueness: { message: 'Project name must be unique. "%{value}" is already taken' }
  validates :name, presence: { message: "Project name can't be blank"}

  alias_method :collaborators, :users
  alias_method :owner, :user

  def owner=(user)
    self.user = user
  end
end