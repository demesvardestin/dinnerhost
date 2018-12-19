class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'
 
    def welcome_email(user)
        @user = user
        @url  = 'http://example.com/login'
        mail(to: @user.email, subject: 'Welcome to DinnerHost!')
    end
    
    def invite_chef(email, customer)
        @link = "https://dinnerhost.co/referral?ref#{customer.referral_code}"
        mail(to: email, subject: "#{customer.first_name} has invited you to join DinnerHost!")
    end
end
