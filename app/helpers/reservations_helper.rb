module ReservationsHelper
    
    def reservation_tips
        ["You are responsible for providing the ingredients, as well as things
        such as cutlery, table accessories, and any additional dinner arrangements.",
        "Make sure to specify any potential allergen to you or anyone present.
        If you forgot to do so on the previous page, be sure to send the cook
        a private message detailing those allergens.",
        "Only make payments through DinnerHost. We can't track payments made outside of DinnerHost.",
        "Listings asking for payments outside of the DinnerHost platform are likely unsecure.",
        "Pay special attention to listings with substantial grammatical errors, bare descriptions,
        lack of images or poor ratings.", "We vet cooks to the best of our ability,
        but our system is far from perfect. Therefore, always use your best
        judgement when making reservations."]
    end
    
    def get_fee(meals, people)
        meal_count = meals.split(',').length
        people_count = people.to_i > 2 ? people.to_i - 2 : 0
        rebate = meal_count - 1
        50 + (people_count * 15) + ((rebate < 0 ? 0 : rebate) * 10)
    end
    
end
