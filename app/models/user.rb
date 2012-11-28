class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates_presence_of :lastname, :firstname
  validates_uniqueness_of :lastname, :firstname, :email, :case_sensitive => false
  has_and_belongs_to_many :games
end
