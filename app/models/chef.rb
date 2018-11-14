class Chef < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :meals, dependent: :destroy
  has_many :messages, through: :conversations
  has_many :conversations
  
  geocoded_by :full_address
  after_validation :geocode
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def full_address
    [street_address, town, state, zipcode].join(' ')
  end
  
end
