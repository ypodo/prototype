class Invite < ActiveRecord::Base
  attr_accessible :name, :mail, :number
  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 40 }
  validates :number, :presence =>true, :length => {:maximum => 11 }
  validates :mail, :length => {:maximum => 50 }
  validates_format_of :number, :with => /^(0\d\d\d\d\d\d\d\d\d)\z|^(0\d\d\d\d\d\d\d\d)\z/
  validates :user_id, :presence => true  
end
