class CreateInviteHistories < ActiveRecord::Migration
  def change
    create_table :invite_histories do |t|
      t.string :name
      t.string :mail
      t.string :number
      t.integer :user_id
      t.string :payer_id
      t.string :event

      t.timestamps
    end
  end
end
