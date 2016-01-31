class Project < ActiveRecord::Base
  belongs_to :user
  has_many :votes

  validates_presence_of :name, :description

  def values_from_json json
    self.name = json["name"]
    self.description = json["description"]
  end

  def render_with_likes
    {
      id: id,
      name: name,
      description: description,
      creator: user.name,
      votes: voters.map(&:name)
    }
  end

  def voters
    votes.map(&:user)
  end

  # This action is very permissive.
  # It doesn't report errors, and if
  # a user has already voted for an item
  # it silently ignores it. A user cannot
  # vote more than once.
  def add_vote user
    Vote.create(project: self, user: user) unless voters.include?(user)
  end

  # Like the `add_vote` method, this is
  # a very permissive one. If the user
  # hasn't like this item, then it still
  # returns a success.
  def remove_vote user
    update_attribute(:votes, self.votes - Vote.where(project: self, user: user))
  end
end
