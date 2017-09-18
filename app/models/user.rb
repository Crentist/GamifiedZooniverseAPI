class User < ApplicationRecord
  has_many :projects
  validates_presence_of :zooniverseHandle
end
