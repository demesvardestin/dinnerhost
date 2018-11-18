module MealsHelper
    
    def booking_controls
        current_chef ? 'cook_controls' : 'customer_controls'
    end
end
