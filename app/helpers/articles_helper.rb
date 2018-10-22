module ArticlesHelper
    
    def related_articles
        Article.all
    end
    
    def post_categories
        ["Legal", "Sales", "Software", "Marketing", "Employees", "HIPAA"]
    end
    
end
