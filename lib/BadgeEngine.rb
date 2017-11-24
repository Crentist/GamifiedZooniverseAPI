class BadgeEngine

  def self.checkCriteriaAndIssue(user)
    #byebug
    badges = Badge.all
    badges.each do |b|
      #cumple el usuario con el o los criterios?
      JSON.parse(b.criteria).each do |criteriaType, criteriaValue|
        if self.userMeetsCriteria(user,criteriaType,criteriaValue)
          self.issueBadge(user,b)
        end
      end
    end
  end

  private

  def self.issueBadge(user,b)
    user.addBadge(b)
  end

  def self.userMeetsCriteria(user, type, value)
    #byebug
    user.public_send(type) == value - 1
  end
end