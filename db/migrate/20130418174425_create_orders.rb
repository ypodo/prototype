class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :token
      t.integer :amount
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
