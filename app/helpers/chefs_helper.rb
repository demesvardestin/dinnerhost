module ChefsHelper
    
    def cook_report_categories
        ["This is not a real cook", "This cook has fradulent listings", "This cook has offensive listings", "It's something else"]
    end
    
    def star_rating(star, chef)
        star.to_i <= chef.average_rating.to_i ? 'fa fa-star theme-cyan' : 'fa fa-star-o theme-cyan'
    end
    
    def background_color_status_for(res_id)
        res = Reservation.find_by(id: res_id)
        return if res.nil?
        case res.status
        when "pending"
            "background-cyan"
        end
    end
    
    def pending_reservations
        current_chef.reservations.pending.any? ? true : false
    end
    
    def pending_reservations_count
        current_chef.reservations.pending.count
    end
    
end
