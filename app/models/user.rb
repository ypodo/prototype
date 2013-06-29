require 'digest'
class User < ActiveRecord::Base
  
  #category
  #has_one :category
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :agreement ,:provider, :uid, :category
  #Inite runtime
  has_many :invites
  has_many :invites, :dependent => :destroy
  #invite_history
  has_many :inviteHistorys
  has_many :inviteHistorys, :dependent => :destroy
  
  #order details
  has_many :orders
  has_many :orders, :dependent => :destroy

  #File hash
  has_many :audio_file
  has_many :orders, :dependent => :destroy
  
  validates :name,  :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true
  validates :password, :presence => true, :confirmation => true, :length => { :within => 2..40 }
  before_create :encrypt_password
  
  cattr_accessor :skip_callbacks
  before_save :encrypt_password, :unless => :skip_callbacks
  
  # Cosial
  has_many :authentications
  validates :name, :email, :presence => true
  
  #password reset
  before_create { generate_token(:auth_token) }
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now    
    save(:validate => false)
    #save!
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.email=auth["info"]["email"]
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.password=auth["uid"]
    end
    user=User.find_by_email(auth["info"]["email"])
    fileH=user.audio_file.new
    fileH.audio_hash=Digest::SHA2.hexdigest(fileH.user_id.to_s)[0..32]
    fileH.save
    user
  end
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
