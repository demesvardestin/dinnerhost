module ApplicationHelper
    
    def url
        request.original_url
    end
    
    def navbar
        if current_chef
            'layouts/chef_navbar'
        elsif current_customer
            'layouts/customer_navbar'
        else
            'layouts/main_navbar'
        end
    end
    
    def body
        if current_chef
            'layouts/chef_body'
        elsif current_customer
            'layouts/customer_body'
        else
            'layouts/main_body'
        end
    end
    
    def footer
        current_chef || current_customer ? 'layouts/no_footer' : 'layouts/footer'
    end
    
    def unescape(content)
        URI.unescape(content)
    end
    
    def encode(string)
        URI.encode(string)
    end
    
    def decode(string)
        URI.decode(string)
    end
    
    def user
        current_chef || current_customer
    end
    
    def current_user
        user
    end
    
    def inbox_status
        messages = []
        user.conversations.each do |c|
            messages << c.messages.select do |m|
                m.created_at > c.last_accessed.to_datetime && m.sender != user if !c.last_accessed.nil?
            end
        end
        if messages.flatten.any?
            "fa fa-circle theme-green"
        end
    end
    
    def star_rating(star, chef)
        star.to_i <= chef.average_rating.to_i ? 'fa fa-star theme-cyan' : 'fa fa-star-o theme-cyan'
    end
    
    def meal_star_rating(star, meal)
        star.to_i <= meal.average_rating.to_i ? 'fa fa-star theme-cyan' : 'fa fa-star-o theme-cyan'
    end
    
    def popular_categories
        ["Chinese", "Italian", "Mexican", "Mediterranean", "Caribean"]
    end
    
    def user_location
        request.location
    end
    
    def check_referrals(chef)
        referral = chef.referral
        return if referral.applied
        customer = Customer.find_by(referral_code: referral.code_value)
        customer.update(credit_value: customer.credit_value + 20.0)
        referral.update(applied: true)
    end
    
    def param_selected(param, value, _filters=nil)
        if (_filters || params[:filters])
            filters = _filters || JSON.parse(params[:filters])
            if filters["#{param}"] == value
                "fa fa-circle theme-cyan"
            else
                "fa fa-circle-thin"
            end
        else
            "fa fa-circle-thin"
        end
    end
    
end
