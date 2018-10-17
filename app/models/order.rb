class Order < ApplicationRecord
    
    belongs_to :cart
    
    scope :week, -> { where(created_at: DateTime.now.at_beginning_of_week.utc..Time.now.utc) }
    scope :last_week, -> { where(created_at: DateTime.now.at_beginning_of_week.last_week.utc..DateTime.now.at_end_of_week.last_week.utc) }
    scope :two_weeks_ago, -> { where(created_at: DateTime.now.at_beginning_of_week.last_week.last_week.utc..DateTime.now.at_end_of_week.last_week.last_week.utc) }
    scope :month, -> { where(created_at: DateTime.now.at_beginning_of_month.utc..Time.now.utc) }
    scope :year, -> { where(created_at: DateTime.now.at_beginning_of_year.utc..Time.now.utc) }
    
    def item_count
        self.item_list_count.split(',').map {|i| i.to_i }.sum
    end
    
    def total_cost
        total.to_f.round(2)
    end
    
    def self.total_earnings
        self.sum(&:total_cost).round
    end
    
end
