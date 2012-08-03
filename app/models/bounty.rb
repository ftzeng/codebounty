class Bounty < ActiveRecord::Base
  attr_accessible :deadline, :description, :problem, :status, :progress, :interest

  has_many :user_bounties, :dependent => :destroy
  has_many :users, :through => :user_bounties
  has_many :votes, :dependent => :destroy

  validates :deadline, :description, :problem, :presence => true

  after_initialize :init

  def isClaimed?
  	if self.user_bounties.where( :owner => false ).length == 0
      return false
    end
    return true
  end

  def status? 
    if self.status == 0
      return "Unclaimed"
    elsif self.status == 1
      return "Claimed"
    elsif self.status == 2
      return "Completed"
    end
  end

  def owner
  	@owner = self.user_bounties.find_by_owner(true)
  end

  def claimers
  	@claimers = self.user_bounties.where( :owner => false )
  end

  def init
    self.interest = self.interest || 0
    self.status = self.status || 0
    self.progress = self.progress || 0
  end

end
