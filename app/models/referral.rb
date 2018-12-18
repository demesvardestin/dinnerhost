class Referral < ApplicationRecord
    has_one :chef
    
    scope :unapplied, -> { where(applied: false) }
    
    def self.check_referrals(chef)
        referral = chef.referral
        return if !referral || (referral && referral.applied)
        customer = Customer.find_by(referral_code: referral.code_value)
        customer.update(credit_value: customer.credit_value + 5.0)
        referral.update(applied: true)
        
        ## Email referrer to alert that credit has been applied
        MessageUpdate.credit_applied(customer)
    end
end
