class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation, :remember_me, :timezone

  validates_presence_of :lastname, :firstname
  has_many :seats
  has_many :games, :through => :seats

  validate :unique_first_and_last_name

  def unique_first_and_last_name
    errors.add(:base, "User name must be unique") if User.where({:firstname => firstname, :lastname => lastname}).where("id != (?)", id == nil ? 0 : id).count > 0
  end

  def fullname
    return "%s %s" % [firstname, lastname]
  end
end
