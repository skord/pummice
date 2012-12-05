class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :lastname, :firstname, :email, :password, :password_confirmation, :remember_me, :timezone
  # attr_accessible :title, :body

  validates_presence_of :lastname, :firstname
  has_and_belongs_to_many :games

  validate :unique_first_and_last_name

  def unique_first_and_last_name
    false if User.where({:firstname => firstname, :lastname => lastname}).count > 0
  end
end
