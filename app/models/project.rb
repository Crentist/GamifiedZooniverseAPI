class Project < ApplicationRecord
  has_many :users, through: :collaborations
  validates_presence_of :name
end
