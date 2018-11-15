class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         
  has_many :meals, through: :reservations
  has_many :reservations
  has_many :messages, through: :conversations
  has_many :conversations
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def has_archived(convo)
    self.conversations.include?(convo) && convo.archived_by.include?(self.user_type)
  end
  
end
