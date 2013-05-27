class AddArrivingToInviteHistory < ActiveRecord::Migration
  def change
    add_column :invite_histories, :arriving, :integer
  end
end
