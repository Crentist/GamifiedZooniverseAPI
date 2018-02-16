class User < ApplicationRecord
  has_many :collaborations
  has_many :projects, through: :collaborations
  has_many :owned_projects, :class_name => 'Project'
  has_and_belongs_to_many :badges
  has_many :project_badges, through: :project


  validates :handle, presence: { message: "handle can't be blank" }, uniqueness: { message: "handle must be unique"}
  validates :password, presenc: { message: "password can't be blank"}

  def classification_count
    #global amount of classifications. Generic, non-project badge
    collaborations.sum {|c| c.classification_count }
  end

  def addBadge(badge)
    self.badges << badge #???
    self.save!
  end

  def has_badge(badge_id)
    !!self.badges.find(badge_id)
  end

end
