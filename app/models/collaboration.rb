class Collaboration < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :project_badges

  alias_method :collaborator, :user
  #alias_method :date, :created_at

  require 'BadgeEngine'

  @@tasksValues = { "simpleQuestion" => 5, "drawing" => 10 } # Esto a un archivo de config

  def increment(tasks)
    self.points ||= 0
    self.classification_count ||= 0
    self.classification_count += 1
    tasks.each { |tarea| self.points += @@tasksValues[tarea]}
    BadgeEngine.checkCriteriaAndIssue(self.user)
    #ProjectBadgeEngine::checkCriteriaAndIssue(self, self.user)
    self.save!
  end
end