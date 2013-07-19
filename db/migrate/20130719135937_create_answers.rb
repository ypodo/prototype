class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean :selected
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
