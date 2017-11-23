class Badge < ApplicationRecord
  has_and_belongs_to_many :users#, through: :collaborations

  validates :name, presence: { message: "Badge name can't be blank"}
  validates :description, presence: { message: "Badge description can't be blank"}
  validates :criteria, presence: { message: "Badge criteria can't be blank"}
end
