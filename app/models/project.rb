class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  belongs_to :user#, :class_name => 'User'#, :optional => true

  validates_presence_of :name

  alias_method :collaborators, :users
  alias_method :owner, :user
end