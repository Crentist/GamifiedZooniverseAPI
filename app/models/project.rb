class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  validates_presence_of :name
end

#def users
#  collaborations.users.map { |c| c.id; c.zooniverseHandle; c.points }
#end