class UserMailer < ApplicationMailer
    default from: 'DinnerHost'
 
    def welcome_email(user)
        @user = user
        @url  = 'http://example.com/login'
        mail(to: @user.email, subject: 'Welcome to DinnerHost!')
    end
    
    def invite_chef(email, customer)
        @customer = customer
        @link = "https://dinnerhost.co/referral?ref#{@customer.referral_code}"
        mail(to: email, subject: "#{@customer.first_name} has invited you to join DinnerHost!")
    end
    
    def reservation_accepted(reservation)
        @reservation = reservation
        @diner = @reservation.customer
        @chef = @reservation.chef
        @ingredients = @reservation.ingredients_needed
        
        mail(to: @diner.email, subject: "#{@chef.first_name} has accepted your reservation!")
    end
    
    def reservation_denied(reservation)
        @diner = reservation.customer
        @chef = reservation.chef
        
        mail(to: @diner.email, subject: "#{@chef.first_name} was unable to accept your reservation.")
    end
    
    def booking_complete(reservation)
        @diner = reservation.customer
        @chef = reservation.chef
        
        mail(to: @diner.email, subject: "Your reservation request has been sent out!")
    end
    
    def new_reservation_request(reservation)
        @reservation = reservation
        @diner = @reservation.customer
        @chef = @reservation.chef
        
        mail(to: @chef.email, subject: "New Reservation Request!")
    end
end
