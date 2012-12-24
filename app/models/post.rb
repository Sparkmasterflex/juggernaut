class Post < ActiveRecord::Base
  
  class Categories
    UNCATEGORIZED  =  0
    TRAVEL         = 10
    PROJECT        = 20
    TECHNOLOGY     = 30
    RANT           = 40
    JANE           = 50

    LABELS = {UNCATEGORIZED => 'Uncategorized', TRAVEL => 'Travel/Vacation', PROJECT => 'Projects', TECHNOLOGY => 'Technology', RANT => 'My Rants'}
  end
  
  attr_accessible :title, :preview, :body, :category, :author_id
  
  has_many :images, :as => :attachable
  belongs_to :author, :class_name => "User"
  
  validates :title, :preview, :body, :presence => true
  validates :title, :uniqueness => true
  
  # Returns string related to category
  #
  # ==== Returns:
  # String
  def category_label
    Categories::LABELS[category]
  end
  
  def as_json options={}
    attr = {}
    attributes.each do |key, value|
      attr.merge!({key => value}) unless [:created_at, :updated_at].include?(key)
      attr.merge!({key => value.strftime("%m/%d/%Y")}) if [:created_at, :updated_at].include?(key)
    end
    
    attr.merge!({
      :author_name => author.name,
      :category_label => category_label
    })
    
  end
end
