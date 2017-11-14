class Collaboration < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :project_badges

  alias_method :collaborator, :user
  #alias_method :date, :created_at
end