class User < ApplicationRecord
  has_many :projects, through: :collaborations
  validates_presence_of :zooniverseHandle
end
