class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :name
      t.string :mail
      t.string :phone
      t.boolean :returned
      t.string :user

      t.timestamps
    end
  end
end
