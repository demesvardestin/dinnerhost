module ApplicationHelper
    
    def stripe_key
        Rails.env == "development" ? "pk_test_4rlj7z7bgOSQVv1TrZAMhrJi" : ENV["STRIPE_PUBLISHABLE"]
    end
    
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
    
    def diner_star_rating(star, customer)
        star.to_i <= customer.average_rating.to_i ? 'fa fa-star theme-cyan' : 'fa fa-star-o theme-cyan'
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
    
    def hours
        ['12:00AM', '12:30AM', '1:00AM', '1:30AM', '2:00AM', '2:30AM', '3:00AM', '3:30AM', '4:00AM', '4:30AM', '5:00AM', '5:30AM', '6:00AM', '6:30AM',
        '7:00AM', '7:30AM', '8:00AM', '8:30AM', '9:00AM', '9:30AM', '10:00AM', '10:30AM', '11:00AM', '11:30AM', '12:00PM', '12:30PM', '1:00PM', '1:30PM',
        '2:00PM', '2:30PM', '3:00PM', '3:30PM', '4:00PM', '4:30PM', '5:00PM', '5:30PM', '6:00PM', '6:30PM',
        '7:00PM', '7:30PM', '8:00PM', '8:30PM', '9:00PM', '9:30PM', '10:00PM', '10:30PM', '11:00PM', '11:30PM'] 
    end
    
    def page(page)
        url.include? page
    end
    
    def home_page
        current_page? root_url
    end
    
end
