module CartHelper
    
    def date(day)
        case day
        
        when 'today'
            Date.today.strftime('%a, %B %e, %Y')
        when 'tomorrow'
            Date.tomorrow.strftime('%a, %B %e, %Y')
        when '2 days'
            2.days.from_now.strftime('%a, %B %e, %Y')
        when '3 days'
            3.days.from_now.strftime('%a, %B %e, %Y')
        when '4 days'
            4.days.from_now.strftime('%a, %B %e, %Y')
        when '5 days'
            5.days.from_now.strftime('%a, %B %e, %Y')
        when '6 days'
            6.days.from_now.strftime('%a, %B %e, %Y')
        end
    end
    
    def hours_available
        ['10:00AM - 10:30AM', '10:30AM - 11:00AM', '11:00AM - 11:30AM', '11:30AM - 12:00PM', '12:00PM - 12:30PM', '12:30PM - 1:00PM', '1:00PM - 1:30PM', '1:30PM - 2:00PM',
        '2:00PM - 2:30PM', '2:30PM - 3:00PM', '3:00PM - 3:30PM', '3:30PM - 4:00PM', '4:00PM - 4:30PM', '4:30PM - 5:00PM', '5:00PM - 5:30PM', '5:30PM - 6:00PM', '6:00PM - 6:30PM', '6:30PM - 7:00PM',
        '7:00PM - 7:30PM', '7:30PM - 8:00PM', '8:00PM - 8:30PM', '8:30PM - 9:00PM', '9:00PM - 9:30PM', '9:30PM - 10:00PM'] 
    end
    
    def last_mile_type_for(order)
        type = order.delivery_option.downcase
        if type == "delivery"
            "Delivering to:"
        else
            "Pickup for:"
        end
    end
    
    def load_taxes_and_fees(cart, type=nil)
        @cart = cart
        @cart.calculate_fees(type)
    end
    
    def load_final(cart, type=nil)
        @cart = cart
        @cart.calculate_final(type)
        # if @cart.get_store.has_a_bank_account
        #     @cart.final.round(2)
        # else
        #     @cart.final_without_fee.round(2)
        # end
    end
    
    def alert_customer(phone, message)
        MessageUpdate.alert_customer(phone, message)
    end
    
end
