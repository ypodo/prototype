class Answer < ActiveRecord::Base
  attr_accessible :selected, :title
  belongs_to :user
end
