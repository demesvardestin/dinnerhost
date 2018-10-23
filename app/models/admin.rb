class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :articles
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def owns(article)
    article.admin_id == self.id
  end
  
end
