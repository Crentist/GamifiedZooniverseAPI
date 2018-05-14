class Project < ApplicationRecord
  has_many :collaborations
  has_many :users, through: :collaborations
  has_many :project_badges, through: :collaborations
  belongs_to :user, :optional => true
  has_many :milestones

  validates :name, uniqueness: { message: 'Project name must be unique. "%{value}" is already taken' }
  validates :name, presence: { message: "Project name can't be blank"}

  alias_method :collaborators, :users
  alias_method :owner, :user

  def owner=(user)
    self.user = user
  end

  def add_collaborator(collaborator)
    self.collaborators << collaborator
    self.save!
  end

  def scoreboard(user_id: nil, offset: 3)
    ordered_collaborations = collaborations.sort_by(&:points).reverse
    rank = {}
    ordered_collaborations.each_with_index { |oc,index| rank[(index+1).to_i] = oc }

    index_in_rank = ordered_collaborations.index { |oc| oc.user.id == user_id.to_i }

    portion = if index_in_rank.present?
      index_in_rank += 1
      ((index_in_rank-3)..(index_in_rank+3)).to_a
    else
      (1..10).to_a
    end

    new_rank = rank.slice(*portion).map do |position,collab|
      {
        position => {
          handle:             collab.user.handle,
          points:               collab.points,
          classification_count: collab.classification_count
        }
      }
    end.reduce({}, :merge)

    new_rank
  end  
end