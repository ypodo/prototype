class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :gpsLatitude
      t.string :gpsLongitude
      t.string :addres
      t.string :link
      t.integer :user_id
      t.string :token
      t.integer :event_id

      t.timestamps
    end
  end
end
