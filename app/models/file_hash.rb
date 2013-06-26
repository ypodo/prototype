class FileHash < ActiveRecord::Base
  attr_accessible :hash, :user_id
  belongs_to :user
end
