class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :admin

  has_many :user_bounties, :dependent => :destroy
  has_many :bounties, :through => :user_bounties
  has_many :votes, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  after_initialize :init

  def init
    self.admin = false
  end
end
