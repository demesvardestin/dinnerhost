module ChefsHelper
    
    def cook_report_categories
        ["This is not a real cook", "This cook has fradulent listings", "This cook has offensive listings", "It's something else"]
    end
    
    def star_rating(star, chef)
        star.to_i <= chef.average_rating.to_i ? 'fa fa-star theme-cyan' : 'fa fa-star-o theme-cyan'
    end
    
end
