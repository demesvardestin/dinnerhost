class Article < ApplicationRecord
    
    belongs_to :admin
    before_create :set_draft
    
    scope :published, -> { where(draft: false) }
    scope :drafted, -> { where(draft: true) }
    
    validates_presence_of :title
    validates_presence_of :content
    validates_presence_of :tags
    
    def slug
        self.title.split(' ').join('-')
    end
    
    def link
        '/blog/' + self.id.to_s + '/' + self.slug
    end
    
    protected
    
    def set_draft
        
    end
    
end
