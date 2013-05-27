require 'digest'
class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :agreement ,:provider, :uid
  #Inite runtime
  has_many :invites
  has_many :invites, :dependent => :destroy
  #invite_history
  has_many :inviteHistorys
  has_many :inviteHistorys, :dependent => :destroy
  
  #order details
  has_many :orders
  has_many :orders, :dependent => :destroy

  validates :name,  :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true
  validates :password, :presence => true, :confirmation => true, :length => { :within => 2..40 }
  before_save :encrypt_password
  # Cosial
  has_many :authorizations
  validates :name, :email, :presence => true
  

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
