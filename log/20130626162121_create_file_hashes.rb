class CreateFileHashes < ActiveRecord::Migration
  def change
    create_table :file_hashes do |t|
      t.integer :user_id
      t.string :hash

      t.timestamps
    end
  end
end
