class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :votees, :through => :votes
end
