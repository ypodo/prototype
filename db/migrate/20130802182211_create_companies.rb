class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.integer :user_id
      t.string :logoURL
      t.string :webURL
      t.string :email
      t.string :facebookURL
      t.string :googleURL
      t.string :wikiURL
      t.integer :workers
      t.string :presedent
      t.string :otherURL
      t.integer :user_id

      t.timestamps
    end
  end
end
