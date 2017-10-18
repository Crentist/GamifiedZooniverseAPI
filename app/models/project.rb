class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  belongs_to :user#, :class_name => 'User'#, :optional => true

  validates_presence_of :name, :user

  validates :name, uniqueness: { message: 'Project name must be unique. "%{value}" is already taken' }

  alias_method :collaborators, :users
  alias_method :owner, :user

  def owner=(user)
    self.user = user
  end
end