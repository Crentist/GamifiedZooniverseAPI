class Collaboration < ApplicationRecord
  belongs_to :project
  belongs_to :user

  alias_method :collaborator, :user
end