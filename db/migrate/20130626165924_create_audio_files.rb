class CreateAudioFiles < ActiveRecord::Migration
  def change
    create_table :audio_files do |t|
      t.integer :user_id
      t.string :audio_hash

      t.timestamps
    end
  end
end
