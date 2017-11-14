class User < ApplicationRecord
  has_many :collaborations
  has_many :projects, through: :collaborations
  has_many :owned_projects, :class_name => 'Project'

  #validates :zooniverseHandle
  validates :zooniverseHandle, presence: { message: "zooniverseHandle can't be blank" }, uniqueness: { message: "zooniverseHandle must be unique"}
end
