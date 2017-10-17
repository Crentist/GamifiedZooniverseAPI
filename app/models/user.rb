class User < ApplicationRecord
  has_many :collaborations
  has_many :projects, through: :collaborations
  has_many :owned_projects, :class_name => 'Project'

  validates_presence_of :zooniverseHandle
end
