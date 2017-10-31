class Badge < ApplicationRecord
  has_many :collaborations #O es belongs_to??
  has_many :users#, through: :collaborations
  has_one :project, through: :collaborations
end
