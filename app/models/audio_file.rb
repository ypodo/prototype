class AudioFile < ActiveRecord::Base
  attr_accessible :audio_hash, :user_id
  belongs_to :user
end
