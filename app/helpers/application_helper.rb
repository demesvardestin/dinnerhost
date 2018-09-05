module ApplicationHelper
    
    def navbar
        current_store ? 'layouts/store_navbar' : 'layouts/main_navbar'
    end
    
    def footer
        current_store ? 'stores/footer' : 'layouts/footer'
    end
    
end
