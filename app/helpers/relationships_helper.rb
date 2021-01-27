module RelationshipsHelper
  def requesting_friend?(user, friend)
    user.requesting_friends.include?(friend)
  end

  def receiving_friend?(user, friend)
    user.receiving_friends.include?(friend)
  end

  def approved_friend?(user, friend)
    user.approved_friends.include?(friend)
  end
end
