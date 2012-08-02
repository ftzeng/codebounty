class AddOwnerToUserBounties < ActiveRecord::Migration
  def change
    add_column :user_bounties, :owner, :boolean
  end
end
