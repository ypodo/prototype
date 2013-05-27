class InviteHistory < ActiveRecord::Base
  attr_accessible :event, :mail, :name, :number, :token
  belongs_to :user
end
