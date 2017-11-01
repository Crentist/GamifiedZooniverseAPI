class Badge < ApplicationRecord
  has_many :collaborations #O es belongs_to??
  has_many :users#, through: :collaborations
  has_one :project, through: :collaborations

  validates :name, presence: { message: "Badge name can't be blank"}
  validates :description, presence: { message: "Badge description can't be blank"}
  validates :criteria, presence: { message: "Badge criteria can't be blank"}
end
