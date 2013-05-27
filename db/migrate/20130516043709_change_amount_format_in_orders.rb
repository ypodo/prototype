class ChangeAmountFormatInOrders < ActiveRecord::Migration
  def up
    change_column :orders, :amount, :decimal
  end

  def down
  end
end
