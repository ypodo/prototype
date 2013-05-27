class RemovePayerIdFromInviteHistory < ActiveRecord::Migration
  def up
    remove_column :invite_histories, :payer_id
  end

  def down
    add_column :invite_histories, :payer_id, :integer
  end
end
