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
        current_chef ? 'layouts/chef_body' : 'layouts/main_body'
    end
    
    def footer
        current_chef ? 'layouts/no_footer' : 'layouts/footer'
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
    
end
