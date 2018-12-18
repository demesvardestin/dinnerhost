module Recommendation
    
    def recommend_dishes_for(dish)
        meals = Meal.where(meal_type: dish.meal_type).where.not(id: dish.id)
        like = []
        
        dish.tags.split(",").map {|d| !d.empty? }.each do |t|
            like << meals.matches("tags", t)
        end
        
        return like
    end
    
end