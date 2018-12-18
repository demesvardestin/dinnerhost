require './lib/recommendation.rb'

module MealsHelper
    
    include Recommendation
    
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
    
    def social_share_text(listing, social="dinnerhost")
        "This looks so good! '#{listing.name}' @#{social}"
    end
    
    def recommended_dishes(dish)
        meals = Meal.where.not(id: dish.id)
        like = []
        
        dish.tags.split(",").map {|d| d.strip }.each do |t|
            like << meals.matches("tags", t)
        end
        return like.flatten.uniq.first(3) if !like.empty?
        
        fallback = Meal.where.not(id: dish.id).where(meal_type: dish.meal_type).first(3)
        return fallback if !fallback.empty?
        
        further_fallback = Meal.where.not(id: dish.id).first(3)
        return further_fallback
    end
end
