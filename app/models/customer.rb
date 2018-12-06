class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         
  has_many :meals, through: :reservations
  has_many :reservations
  has_many :messages, through: :conversations
  has_many :conversations
  has_many :cook_reports
  has_many :chef_ratings
  has_many :meal_ratings
  has_many :referrals
  
  after_create :set_referral_code
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def full_address
    [street_address, town, state, zipcode].join(' ')
  end
  
  def abridged_address
    [town, state].join(' ')
  end
  
  def has_archived(convo)
    self.conversations.include?(convo) && convo.archived_by.include?(self.user_type)
  end
  
  def has_hosted cook
    cook.reservations.map(&:customer_id).include? id
  end
  
  def has_rated cook
    self.chef_ratings.map(&:chef_id).include? cook.id if cook
  end
  
  def has_not_rated cook
    has_hosted(cook) && !has_rated(cook)
  end
  
  def has_reported cook
    self.cook_reports.map(&:chef_id).include? cook.id if cook
  end
  
  def has_not_reported cook
    !has_reported cook
  end
  
  def has_rated_meal meal
    meal_ratings.map(&:meal_id).include? meal.id if meal
  end
  
  def has_not_rated_meal meal
    !has_rated_meal meal
  end
  
  def referrals
    Referral.where(code_value: referral_code)
  end
  
  def credit_amount
    referrals.unapplied.count * 20.00
  end
  
  private
  
  def set_referral_code
    ref = RandomToken.random(8)
    until !Customer.exists?(referral_code: ref)
      set_referral_code
    end
    self.update(referral_code: ref)
  end
  
end
