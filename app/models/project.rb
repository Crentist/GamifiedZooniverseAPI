class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  validates_presence_of :name

  alias_method :collaborators, :users
end