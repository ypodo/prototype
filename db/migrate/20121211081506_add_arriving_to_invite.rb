class AddArrivingToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :arriving, :integer
  end
end
