class Chef < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  
  has_many :meals, dependent: :destroy
  has_many :messages, through: :conversations
  has_many :conversations
  has_many :cook_reports
  has_many :chef_ratings
  
  geocoded_by :full_address
  after_validation :geocode
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def full_address
    [street_address, town, state, zipcode].join(' ')
  end
  
  def has_archived(convo)
    self.conversations.include?(convo) && convo.archived_by.include?(self.user_type)
  end
  
  def average_rating
    (self.chef_ratings.map(&:value).sum/self.rating_count).to_f
  end
  
  def rating_count
    self.chef_ratings.count
  end
  
end
