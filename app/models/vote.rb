class Vote < ActiveRecord::Base
  attr_accessible :bounty_id, :user_id, :value

  belongs_to :user
  belongs_to :bounty

end
