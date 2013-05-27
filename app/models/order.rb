class Order < ActiveRecord::Base
  attr_accessible :amount, :first_name, :last_name, :token, :user_id
  belongs_to :user
end
