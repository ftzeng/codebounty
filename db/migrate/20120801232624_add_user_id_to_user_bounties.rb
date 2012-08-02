class AddUserIdToUserBounties < ActiveRecord::Migration
  def change
    add_column :user_bounties, :user_id, :integer
  end
end
