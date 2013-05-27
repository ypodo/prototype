class AddTokenToInviteHistory < ActiveRecord::Migration
  def change
    add_column :invite_histories, :token, :string
  end
end
