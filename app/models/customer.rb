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
  has_many :diner_ratings
  has_many :referrals
  has_many :reservation_cancellations
  has_many :wishlists
  
  after_create :set_referral_code, :create_rating, :send_welcome_email
  
  mount_uploader :image, ImageUploader
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def full_address(location=nil)
    address = [street_address, town, state, zipcode].join(' ')
    address = if address.strip.empty?
      location
    else
      address
    end
  end
  
  def abridged_address
    [town.capitalize, state.upcase].join(' ')
  end
  
  def has_archived(convo)
    self.conversations.include?(convo) && convo.archived_by.include?(self.user_type)
  end
  
  def has_saved meal
    wishlists.map(&:meal_id).include? meal.id
  end
  
  def can_rate meal
    reservations.map(&:meals).flatten.include?(meal) && has_not_rated_meal(meal)
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
  
  def average_rating
    begin
      (diner_ratings.map(&:value).sum/rating_count).to_f
    rescue
      1
    end
  end
  
  def rating_count
    diner_ratings.count
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
    referrals.unapplied.count * 5.00
  end
  
  def accept_guidelines
    update(accepted_guidelines_on: Time.zone.now)
  end
  
  private
  
  def set_referral_code
    ref = RandomToken.random(8)
    until !Customer.exists?(referral_code: ref)
      set_referral_code
    end
    self.update(referral_code: ref)
  end
  
  def create_rating
    DinerRating
    .create(value: 5, chef_id: 1, customer_id: self.id, details: "This is an automated DinnerHost bot review.")
  end
  
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
  
end
