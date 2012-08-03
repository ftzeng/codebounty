class AddInterestToBounty < ActiveRecord::Migration
  def change
    add_column :bounties, :interest, :integer
  end
end
