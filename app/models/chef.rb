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
  has_many :diner_ratings
  has_many :reservations
  belongs_to :referral
  
  geocoded_by :full_address
  after_validation :geocode
  
  mount_uploader :image, ImageUploader
  
  after_create :create_rating, :create_shortened_url
  
  scope :live, -> { where(live: true) }
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def full_address
    [street_address, town, state, zipcode].join(' ')
  end
  
  def abridged_address
    [town.capitalize, state.upcase].join(' ')
  end
  
  def join_date
    "Joined " + created_at.strftime('%B %Y')
  end
  
  def has_archived(convo)
    conversations.include?(convo) && convo.archived_by.include?(user_type)
  end
  
  def has_rated customer
    diner_ratings.map(&:customer_id).include? customer.id if customer
  end
  
  def has_not_rated customer
    !has_rated(customer)
  end
  
  def average_rating
    begin
      (chef_ratings.map(&:value).sum/rating_count).to_f
    rescue
      1
    end
  end
  
  def rating_count
    chef_ratings.count
  end
  
  def accept_reservation(reservation)
    reservation.update(accepted: true, accepted_on: Time.zone.now)
  end
  
  def deny_reservation(reservation)
    reservation.update(accepted: false, denied_on: Time.zone.now)
  end
  
  def is_verified
    [[instagram, "Instagram"], [facebook, "Facebook"],
      [twitter, "Twitter"], [email, "Email"], [phone_number, "Phone number"]]
  end
  
  def has_about_info
    education.present? && languages.present?
  end
  
  def verify
    update(verified: true)
  end
  
  def self.find_near(address)
    self.near(address, 15)
  end
  
  def earnings
    reservations.accepted.map {|r| r.fee.to_f  * 0.85 }.sum.round(2)
  end
  
  def remove_stripe
    update(has_stripe_account: false, stripe_token: nil)
  end
  
  def can_message diner
    reservations.map(&:customer_id).include? diner.id
  end
  
  def cannot_message diner
    !can_message diner
  end
  
  protected
  
  def create_rating
    ChefRating
    .create(value: 5, chef_id: self.id, customer_id: 1, details: "This is an automated DinnerHost bot review.")
  end
  
  def create_shortened_url
    self.update(shortened_url: RandomToken.random(8))
  end
  
end
