module MealsHelper
    
    def booking_controls
        current_chef ? 'cook_controls' : 'customer_controls'
    end
    
    def meal_report_categories
        ["This is not a real cook", "This cook has fradulent listings", "This cook has offensive listings", "It's something else"]
    end
    
    def meal_report_header(step, text=nil)
        case step.downcase
        when 'intro'
            "Why are you reporting this meal?"
        else
            case text.downcase
            when "it's a scam"
                "Why do you believe this meal is a scam?"
            when "it's innacurate"
                "What makes this meal innacurate?"
            when "it's offensive"
                "What makes this meal offensive?"
            else
                "Please provide more details for your report"
            end
        end
    end
end
