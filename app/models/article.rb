class Article < ApplicationRecord
    
    belongs_to :admin
    
    validates_presence_of :title
    validates_presence_of :content
    validates_presence_of :tags
    
    def slug
        self.title.split(' ').join('-')
    end
    
    def link
        '/blog/' + self.id.to_s + '/' + self.slug
    end
    
end
