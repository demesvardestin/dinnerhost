class ShopperMailer < ApplicationMailer
    default :from => 'hello@senzzu.com'
    
    # send a signup email to the user, pass in the user object that   contains the user's email address
    def order_receipt(email, cart, order)
        @email = email
        @cart = cart
        @order = order
        mail(to: @email,
            subject: 'Thank you for ordering on Senzzu!')
    end
end
