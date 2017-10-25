class Collaboration < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :badges

  alias_method :collaborator, :user
end