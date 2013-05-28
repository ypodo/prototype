class Location < ActiveRecord::Base
  attr_accessible :addres, :event_id, :gpsLatitude, :gpsLongitude, :link, :token, :user_id
  belongs_to :user
  
end
