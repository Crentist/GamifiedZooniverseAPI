class ProjectBadge < Badge
  belongs_to :project, optional: true
  has_many :collaborations
  has_many :users, through: :collaborations

end