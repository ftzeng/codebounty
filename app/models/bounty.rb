class Bounty < ActiveRecord::Base
  attr_accessible :deadline, :description, :problem

  has_many :user_bounties
  has_many :users, :through => :user_bounties

  validates :deadline, :description, :problem, :presence => true

  after_initialize :init

  def isClaimed?
  	# check if claimed
  end

  def owner
  	@owner = self.user_bounties.find_by_owner(true)
  end

  def claimers
  	@claimers = self.user_bounties.where( :owner => false )
  end

  def init 
  	self.claimed = false
  end
end
