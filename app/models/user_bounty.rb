class UserBounty < ActiveRecord::Base
  attr_accessible :user, :owner

  belongs_to :user
  belongs_to :bounty

  after_initialize :init

  def init
  	self.owner = self.owner || false
  end
end
