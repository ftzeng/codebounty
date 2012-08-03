class AddStatusToBounty < ActiveRecord::Migration
  def change
    add_column :bounties, :status, :integer
  end
end
