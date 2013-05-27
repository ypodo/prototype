class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :name
      t.string :mail
      t.string :number
      t.integer :user_id

      t.timestamps
      
    end
    
    add_index :invites, :user_id
  end
end
