class Phone < ActiveRecord::Base
  attr_accessible :mail, :name, :phone, :returned, :user
end
