class ProjectBadge < Badge
  belongs_to :project
  has_many :collaborations
  has_many :users, through: :collaborations

end