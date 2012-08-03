class AddProgressToBounty < ActiveRecord::Migration
  def change
    add_column :bounties, :progress, :float
  end
end
