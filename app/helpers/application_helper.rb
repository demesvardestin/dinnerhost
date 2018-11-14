module ApplicationHelper
    
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
    
end
