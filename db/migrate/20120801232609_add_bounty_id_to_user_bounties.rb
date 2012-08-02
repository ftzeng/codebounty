class AddBountyIdToUserBounties < ActiveRecord::Migration
  def change
    add_column :user_bounties, :bounty_id, :integer
  end
end
